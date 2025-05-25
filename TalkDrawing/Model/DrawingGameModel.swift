import Foundation
import UIKit

enum DrawingGameError: Error {
    case jsonSerializationFailed
    case networkError(Error)
    case invalidResponse
    case taskFailed(String)
}

struct DrawingConfig {
    static let baseURL = "https://aip.baidubce.com/rpc/2.0/ernievilg/v1"
    static let textToImage = "/txt2img"
    static let getImage = "/getImg"
}

class DrawingGameModel {
    private var accessToken = ""
    private(set) var imgUrl = ""
    
    func saveComics(images: [UIImage]) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsDirectory.appendingPathComponent("SavedImages")
    
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating local images folder: \(error)")
            }
        }
        do {
            for (index, image) in images.enumerated() {
                let timestamp = Date().timeIntervalSince1970
                let fileURL = folderURL.appendingPathComponent("image\(timestamp)_\(index).png")
                if let data = image.pngData() {
                    try data.write(to: fileURL)
                    print("[DrawingGameModel] Image saved successfully")
                }
            }
        } catch {
            print("[DrawingGameModel] Error saving images locally: \(error)")
        }
    }
}

// MARK: - 百度AI绘画API
extension DrawingGameModel {
    func performAskImage(text: String, semaphore: DispatchSemaphore) {
        let parameters: [String: Any] = [
            "text": text,
            "resolution": "1024*1024",
            "style": "卡通画",
            "num": 1
        ]
        
        let urlString = "\(DrawingConfig.baseURL)\(DrawingConfig.textToImage)?access_token=\(accessToken)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        do {
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                if let error = error {
                    print("请求文字转换图片时错误: \(error)")
                    semaphore.signal()
                    return
                }
                guard let data = data else {
                    print("请求文字转图片返回的 data = nil")
                    return
                }
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("请求文字转图片，解析data失败")
                    return
                }

                        
                guard let taskData = json["data"] as? [String: Any],
                let taskId = taskData["taskId"] as? Int else {
                      print("请求文字转图片，解析taskId失败，json = \(json)")
                      semaphore.signal()
                      return
                  }
                
                print("解析 ImageRequestData 成功，taskId = \(taskId)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.performGetImage(id: String(taskId), semaphore: semaphore)
                }
            }
            task.resume()
        } catch {
            print("创建请求失败: \(error)")
            semaphore.signal()
        }
    }
    
    private func performGetImage(id: String, semaphore: DispatchSemaphore, retryCount: Int = 0) {
        let maxRetries = 3
        let parameters: [String: Any] = ["taskId": id]
        let urlString = "\(DrawingConfig.baseURL)\(DrawingConfig.getImage)?access_token=\(accessToken)"
        
        guard let url = URL(string: urlString) else {
            semaphore.signal()
            return
        }
        
        var request = URLRequest(url: url)
        do {
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                if let error = error {
                    print("请求返回图片时错误: \(error)")
                    semaphore.signal()
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let responseData = json["data"] as? [String: Any] else {
                    print("解析返回数据失败")
                    semaphore.signal()
                    return
                }
                
                let status = responseData["status"] as? Int ?? 0
                let waiting = responseData["waiting"] as? String ?? "3s"
                print("图片生成状态: \(status), waiting: \(waiting)")
                
                // 尝试获取图片URL
                var imageUrl: String? = nil
                if let imgUrls = responseData["imgUrls"] as? [[String: Any]], !imgUrls.isEmpty {
                    imageUrl = imgUrls[0]["image"] as? String
                }
                if imageUrl == nil {
                    imageUrl = responseData["img"] as? String
                }
                
                if status == 1, let finalUrl = imageUrl {
                    // 将 http 替换为 https
                    let secureUrl = finalUrl.replacingOccurrences(of: "http://", with: "https://")
                    self?.imgUrl = secureUrl
                    semaphore.signal()
                } else if retryCount < maxRetries {
                    let waitingSeconds = Int(waiting.replacingOccurrences(of: "s", with: "")) ?? 3
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(waitingSeconds)) {
                        print("重试获取图片，waiting: \(waitingSeconds)")
                        self?.performGetImage(id: id, semaphore: semaphore, retryCount: retryCount + 1)
                    }
                } else {
                    print("达到最大重试次数，图片生成可能失败")
                    semaphore.signal()
                }
            }
            task.resume()
        } catch {
            print("创建请求失败: \(error)")
            semaphore.signal()
        }
    }
}
