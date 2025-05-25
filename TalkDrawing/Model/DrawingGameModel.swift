
import Foundation
import UIKit

class DrawingGameModel {
    /// 生成的图片链接
    private(set) var img = ""
    /// 密钥access_token
    private let access_token = "Your Key"
    /// 文字生成图片请求url
    private let textToImageURL = "https://aip.baidubce.com/rpc/2.0/ernievilg/v1/txt2img?access_token="
    /// 查询生成图片请求url
    private let getImageURL = "https://aip.baidubce.com/rpc/2.0/ernievilg/v1/getImg?access_token="

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
                    print("[DrawingGameModel] Image saved successful")
                }
            }
        } catch {
            print("[DrawingGameModel] Error saving images locally: \(error)")
        }
    }
}

// MARK: - BaiDuAlImage
extension DrawingGameModel {
    /// 请求文字生成图片
    func performAskImage(text: String, semaphore: DispatchSemaphore) {
        print("调用AskImage成功")
        let parameters: [String: Any] = [
            // 输入内容
            "text": text,
            // 图片分辨率，可支持1024*1024、1024*1536、1536*1024
            "resolution": "1024*1024",
            // 支持风格有：探索无限、古风、二次元、写实风格、浮世绘、low poly 、未来主义、像素风格、概念艺术、赛博朋克、洛丽塔风格、巴洛克风格、超现实主义、水彩画、蒸汽波艺术、油画、卡通画
            "style": "卡通画",
            // 图片生成数量，支持1-6张
            "num": 1
        ]
        var request = URLRequest(url: URL(string: textToImageURL+access_token)!)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error: Failed to serialize JSON data.")
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("请求文字转换图片时错误: \(error)")
                return
            }
            
            if let safeData = data {
                if let taskId = self.parseAskImageJSON(safeData) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7){
                        self.performGetImage(id: taskId, semaphore: semaphore)
                    }
                }
            }
        }
        task.resume()
    }
    /// 请求回调图片url
    private func performGetImage(id: String, semaphore: DispatchSemaphore) {
        let parameters: [String: Any] = [
            "taskId": id
        ]
        
        var request = URLRequest(url: URL(string: getImageURL+access_token)!)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error: Failed to serialize JSON data.")
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("请求返回图片时错误: \(error)")
                return
            }
            
            if let safeData = data {
                if let imageURL = self.parseGetImageJSON(safeData) {
                    if imageURL != "" {
                        self.img = imageURL
                        // 释放信号量
                        semaphore.signal()
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.performGetImage(id: id, semaphore: semaphore)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    /// 解析文字请求图片数据
    private func parseAskImageJSON(_ backData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let imageData = try decoder.decode(ImageRequestData.self, from: backData)
            return String(imageData.data.taskId)
        } catch {
            print("解析 ImageRequestData 失败：\(error)")
            return nil
        }
    }
    /// 解析返回图片数据
    private func parseGetImageJSON(_ backData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let backImageData = try decoder.decode(BackImage.self, from: backData)
            return backImageData.data.img
        } catch {
            print("解析 BackImage 失败：\(error)")
            return nil
        }
    }
}


// MARK: - 数据模型
// 画图请求
struct ImageRequestData: Decodable {
    let data: TaskId
}

struct TaskId: Decodable {
    let taskId: Int
}

// 返回图片请求
struct BackImage: Decodable {
    let data: ImageUrl
}

struct ImageUrl: Decodable {
    let img: String
}
