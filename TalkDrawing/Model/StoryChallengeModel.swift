//TO DO
// 1-3,4-6,7+的儿童英文

import Foundation

enum Ages: String {
    case zeroToThree
    case foreToSix
    case SenvenPlus
}

struct StoryChallengeModel: Identifiable {
    internal let id = UUID().uuidString
    // 板块标题和图片
    let title: String
    // 板块年龄段
    let age: Ages
    // 是否已经解锁
    var isLocked: Bool = true
    // 子Stories
    var stories = [Story]()
    
    // 当前游戏主要内容
    static let storyChallenges = [
        StoryChallengeModel(title: "经典儿歌", age: .zeroToThree, isLocked: false, stories: [
            Story(title: "门前大桥下", parentTitle: "经典儿歌"),
            Story(title: "两只老虎", parentTitle: "经典儿歌"),
            Story(title: "小燕子", parentTitle: "经典儿歌"),
            Story(title: "丢手绢", parentTitle: "经典儿歌"),
        ]),
        StoryChallengeModel(title: "童话寓言", age: .zeroToThree),
        StoryChallengeModel(title: "国学诗词", age: .foreToSix),
        StoryChallengeModel(title: "历史人文", age: .foreToSix),
        StoryChallengeModel(title: "传统文化", age: .foreToSix),
        StoryChallengeModel(title: "自然百科", age: .foreToSix),
        StoryChallengeModel(title: "地理名胜", age: .SenvenPlus),
        StoryChallengeModel(title: "国外绘本", age: .SenvenPlus)
    ]
}
