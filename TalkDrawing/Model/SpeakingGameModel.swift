
import Foundation
import UIKit

struct SpeakingGameModel {
    
    // 保存的连环画资源
    var comics: [UIImage] = []
    
    // 四项语音能力总评: 语言清晰度、语言逻辑性、言语情商能力、语汇能力
    var scores: [Int] = [0, 0, 0, 0]
    // 关键词列表
    /// 语言清晰度
    let clarityKeyWords = ["额", "啊", "嗯", "呃", "恩"]
    /// 语言逻辑性
    let logicKeyWords = ["首先", "其次", "最后", "因此", "另外", "然而", "虽然", "但是"]
    /// 言语情商能力
    let socialKeyWords = ["感谢", "抱歉", "请", "谢谢", "对不起", "好", "没关系", "不用谢"]
    /// 语汇能力
    let vocabularyKeyWords = ["瘦弱", "淳朴", "慈祥", "和蔼", "朴素", "稳重", "红润", "白净", "俏丽", "勤劳", "爽朗", "健壮", "魁梧", "体贴"]
}


// MARK: - 资源选择部分

extension SpeakingGameModel {
    /// 加载连环画
    mutating func loadComics() {
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
                print("Number of images in local folder: \(imageFileURLs.count)")
                comics = images
            } catch {
                print("Error counting images in local folder: \(error)")
            }
        }
    /// 删除连环画
    mutating func deleteComics(at index: Int) {
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
                loadComics() // Refresh savedImages after deletion
            }
        } catch {
            print("Error deleting image: \(error)")
        }
    }
}


// MARK: - 语言能力分析部分

extension SpeakingGameModel {
    // 计算语言能力总分
    mutating func calculateScore(text: String, second: Int) {
        // 计算语言清晰度评分
        var clarityScore = 10
        let totalWords = text.components(separatedBy: CharacterSet.whitespacesAndNewlines).count
        let wordCount = NSCountedSet(array: text.components(separatedBy: CharacterSet.whitespacesAndNewlines))
        for keyword in clarityKeyWords {
            let count = wordCount.count(for: keyword)
            let percentage = Double(count) / Double(totalWords) * 100
            if percentage > 30 {
                clarityScore -= 6
            } else if percentage > 20 {
                clarityScore -= 4
            } else if percentage > 10 {
                clarityScore -= 2
            } else if percentage < 10 && percentage > 4 {
                clarityScore += 3
            } else if percentage <= 4 {
                clarityScore += 6
            }
        }
        scores[0] = clarityScore

        // 计算语言逻辑性评分
        var logicScore = 0
        let logicWords = logicKeyWords.reduce(0) { count, keyword in
            return count + wordCount.count(for: keyword)
        }
        let logicPercentage = Double(logicWords) / Double(totalWords) * 100
        if logicPercentage < 5 {
            logicScore -= 2
        } else if logicPercentage >= 5 && logicPercentage <= 15 {
            logicScore += 6
        } else if logicPercentage > 15 && logicPercentage < 30 {
            logicScore += 3
        }
        scores[1] = logicScore

        // 言语情商能力评分
        var socialScore = 0
        for keyword in socialKeyWords {
            if text.contains(keyword) {
                socialScore += 1
            }
        }
        scores[2] = socialScore
        
        // 语汇能力评分
        var vocabularyScore = 10
        for keyword in vocabularyKeyWords {
            if text.contains(keyword) {
                vocabularyScore += 1
            }
        }
        scores[3] = vocabularyScore
        
        // 最后加上语速得分整理数据
        for index in 0...3 {
            scores[index] += calculateSpeechSpeed()
            if scores[index] > 10 {
                scores[index] = 10
            }
            if scores[index] < 0 {
                scores[index] = 0
            }
        }
        // 计算语速得分
        func calculateSpeechSpeed() -> Int {
            // 语速
            let durationRatio = Double(text.count) / Double(second)
            // 根据语速适当加分
            if durationRatio > 5 && durationRatio <= 7 {
                return 5
            }
            if durationRatio > 3 && durationRatio <= 5 {
                return 3
            }
            if durationRatio > 1 && durationRatio <= 3 {
                return 1
            }
            if durationRatio <= 1 {
                return -6
            }
            return 3
        }
    }
}
