
import Foundation
import UIKit

class SpeakingGameModel {
    var comics: [UIImage] = []
    var scores: [Int] = [0, 0, 0, 0]        // 四项语音能力总评: 语言清晰度、语言逻辑性、言语情商能力、语汇能力
    
    func loadComics() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsDirectory.appendingPathComponent("SavedImages")
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            let imageFileURLs = fileURLs.filter { fileURL in
                let fileExtension = fileURL.pathExtension.lowercased()
                return ["png", "jpg", "jpeg"].contains(fileExtension)
            }
            
            var images: [UIImage] = []
            for fileURL in imageFileURLs {
                if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                    images.append(image)
                }
            }
            self.comics = images
        } catch {
            print("[SpeakingGameModel] Error counting images in local folder: \(error)")
        }
    }
    
    func deleteComics(at index: Int) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsDirectory.appendingPathComponent("SavedImages")
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            let imageFileURLs = fileURLs.filter { fileURL in
                let fileExtension = fileURL.pathExtension.lowercased()
                return ["png", "jpg", "jpeg"].contains(fileExtension)
            }
            
            if index < imageFileURLs.count {
                let fileURLToDelete = imageFileURLs[index]
                try FileManager.default.removeItem(at: fileURLToDelete)
                self.loadComics()
            }
        } catch {
            print("[SpeakingGameModel] Error deleting image: \(error)")
        }
    }
    
    func analyzeSpeech(text: String, duration: Int) {
        let parameters: [String: Any] = [
            "text": text,
            "second": duration
        ]
        let url = URL(string: "http://localhost:8080/api/analyze-speech")!
        var request = URLRequest(url: url)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("[SpeakingGameModel] failed to serialize JSON data.")
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("[SpeakingGameModel] request analyzeSpeech fail with error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print("[SpeakingGameModel] Server returned an error: \(response?.description ?? "")")
                return
            }
            
            guard let safeData = data else {
                print("[SpeakingGameModel] No data received.")
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: safeData, options: []) as? [String: Any] else {
                print("[SpeakingGameModel] failed to deserialize JSON data.")
                return
            }
            
            if let scores = json["scores"] as? [Int] {
                print("[SpeakingGameModel] Received scores: \(scores)")
                self.scores = scores
            } else {
                print("[SpeakingGameModel] Do not received scores data")
            }
        }
        task.resume()
    }
}
