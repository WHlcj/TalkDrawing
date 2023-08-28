
import Foundation

class DrawingGameModel {
    /// 画板
    var canvas = ["何时", "何地", "何人", "何事"]
    /// 生成的图片链接
    var img = ""
    /// 文字生成图片请求url
    private let textToImageURL = "https://aip.baidubce.com/rpc/2.0/ernievilg/v1/txt2img?access_token=24.97d11252c9523083e4f3aed70f905f7b.2592000.1695210623.282335-37996049"
    /// 查询生成图片请求url
    private let getImageURL = "https://aip.baidubce.com/rpc/2.0/ernievilg/v1/getImg?access_token=24.97d11252c9523083e4f3aed70f905f7b.2592000.1695210623.282335-37996049"
}

// MARK: - BaiDuAlImage
extension DrawingGameModel {
    /// 请求文字生成图片
    func performAskImage(text: String) {
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
        var request = URLRequest(url: URL(string: textToImageURL)!)
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
                    self.performGetImage(id: taskId)
                }
            }
        }
        task.resume()
    }
    /// 请求回调图片url
    private func performGetImage(id: String) {
        let parameters: [String: Any] = [
            "taskId": id
        ]
        
        var request = URLRequest(url: URL(string: getImageURL)!)
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
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.performGetImage(id: id)
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
