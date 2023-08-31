
import Foundation
import UIKit

struct SpeakingGameModel {
    
    // 保存的连环画资源
    var comics: [UIImage] = []
    
    // 四项语音能力总评: 语言清晰度、语言逻辑性、言语情商能力、语汇能力
    var scores: [Int] = [0, 0, 0, 0]
    // 关键词列表
    /// 语言清晰度
    let clarityKeyWords = ["额", "啊", "嗯", "呃", "恩", "那个", "这个这个", "那个什么", "呃", "等一下", "怎么说呢", "就是这个样子", "那个意思是", "不过就是", "那个啊", "嗯嗯", "怎么说呢"]
    /// 语言逻辑性
    let logicKeyWords = ["首先", "其次", "最后", "因此", "另外", "然而", "虽然", "但是", "综上所述", "尽管如此", "与此同时", "反之", "比如说", "如前面所说", "相反"]
    /// 言语情商能力
    let socialKeyWords = ["感谢", "抱歉", "请", "谢谢", "对不起", "好", "没关系", "不用谢"]
    /// 语汇能力
    let vocabularyKeyWords = ["瘦弱", "淳朴", "慈祥", "和蔼", "朴素", "稳重", "谦虚", "老练", "温和", "坚定", "坚韧", "睿智", "知性", "精明", "平和", "冷静", "克制", "平易近人", "高尚", "悦耳", "深情", "纯真", "文雅", "高瞻远瞩", "优雅", "宽厚", "安详", "真诚", "豁达", "敬业", "勤奋", "深思熟虑", "雅致", "安静", "意味深长", "坦率", "细致", "机智", "明理", "深刻", "灵活", "深沉", "包容", "适度", "慎重", "温馨", "毅力", "冷静沉着", "考虑周全", "严谨", "善解人意", "正直", "爽朗", "坦然", "踏实", "善良", "贴心", "平静", "具有感染力", "具有说服力", "富有幽默感", "敏感", "意志坚定", "悲观", "乐观", "深切", "外向", "内向", "温柔", "坚强", "独立", "忍耐", "耐心", "热情", "机谨", "踏实稳重", "勇敢", "幽默", "创造力", "灵感", "敏锐", "容易相处", "亲和力", "知足常乐", "无私", "随和", "灵魂深处", "超脱", "坚毅", "明亮", "自信", "豁达大度", "轻松", "高贵", "大气", "踏实肯干", "稳健", "严谨认真", "细心入微", "机智幽默", "才智出众", "深沉内敛", "高尚情操", "开朗乐观", "耐心等待", "严格要求", "经验丰富", "能言善辩", "言之有物", "直率坦诚", "心灵手巧", "思虑周详", "不急不躁", "随机应变", "平易近人", "赤诚相待", "厚道", "和顺", "悉心关怀", "老练成熟", "具有亲和力", "有头有脸", "勤勤恳恳", "细致入微", "明察秋毫", "思路清晰", "表达清楚", "立场坚定", "自律", "丰富阅历", "创新", "多愁善感", "敏感细腻", "机智幽默", "言简意赅", "果断坚决", "勇于担当", "外向活泼", "内敛含蓄", "思考缜密", "耐人寻味", "深思熟虑"]

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
        var clarityScore = 0
        if text.count > 10 { // 识别的文本数量大于10才有分数
            for keyword in clarityKeyWords {
                var count = 0.0
                let totalWords = Double(text.count) / 2
                if text.contains(keyword) {
                    count += 1
                }
                let percentage = count / totalWords * 100
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
        } else {
            scores[0] = 0
        }

        // 计算语言逻辑性评分
        var logicScore = 0
        for keyword in logicKeyWords {
            var count = 0.0
            let totalWords = Double(text.count) / 2
            if text.contains(keyword) {
                count += 1
            }
            let logicPercentage = count / totalWords * 100
            if logicPercentage < 5 {
                logicScore -= 2
            } else if logicPercentage >= 5 && logicPercentage <= 15 {
                logicScore += 7
            } else if logicPercentage > 15 && logicPercentage < 30 {
                logicScore += 4
            }
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
        var vocabularyScore = 0
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
            if durationRatio > 4 && durationRatio <= 7 {
                return 5
            }
            if durationRatio > 2 && durationRatio <= 4 {
                return 3
            }
            if durationRatio > 1 && durationRatio <= 2 {
                return 1
            }
            if durationRatio <= 1 {
                return -6
            }
            return 3
        }
    }
}
