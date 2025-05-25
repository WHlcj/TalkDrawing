
import Foundation
import SwiftUI

enum Ages: String {
    case zeroToThree
    case foreToSix
    case SixPlus
}

struct StoryGameModel {
    var indexOfSelectedChallenge: Int? {
        get {
            challenges.firstIndex(where: { $0.isSelected == true })
        }
    }

    var indexOfSelectedStory: Int? {
        get {
            challenges[indexOfSelectedChallenge ?? 0].stories.firstIndex(where: { $0.isSelected == true })
        }
    }

    private(set) var challenges = [
        StoryChallenge(title: "经典儿歌", age: [.zeroToThree, .foreToSix, .SixPlus], isLocked: false, stories: [
            Story(title: "门前大桥下", parentTitle: "经典儿歌", videoUrl: Bundle.main.url(forResource: "门前大桥下", withExtension: "mp4"), keyWord: "桥", targetFigure: "duck", targetColor: Color(red: 0.98, green: 0.87, blue: 0.30), welcomeSound: "A-河流上有什么", actionTintSound: "A-拖拽", soundUrl: "A-数鸭子"),
            Story(title: "小燕子", parentTitle: "经典儿歌", videoUrl: Bundle.main.url(forResource: "小燕子", withExtension: "mp4"), keyWord: "", targetFigure: "swallow", targetColor: Color.black, welcomeSound: "", actionTintSound: "A-天上飞过什么", soundUrl: "A-小燕子"),
            Story(title: "两只老虎", parentTitle: "经典儿歌"),
            Story(title: "丢手绢", parentTitle: "经典儿歌"),
        ], figures: ["pig", "monkey", "frog", "sheep", "duck", "swallow"]),//"deer", "chicken", "panda", "lion", "monkey", "horse""/
        StoryChallenge(title: "童话寓言", age: [.zeroToThree, .foreToSix, .SixPlus], isLocked: false),
        StoryChallenge(title: "国学诗词", age: [.zeroToThree, .foreToSix, .SixPlus]),
        StoryChallenge(title: "传统文化", age: [.zeroToThree, .foreToSix, .SixPlus]),
        StoryChallenge(title: "自然百科", age: [.zeroToThree, .foreToSix, .SixPlus]),
        StoryChallenge(title: "历史人文", age: [.foreToSix, .SixPlus]),
        StoryChallenge(title: "地理名胜", age: [.foreToSix, .SixPlus]),
        StoryChallenge(title: "国外绘本", age: [.foreToSix, .SixPlus]),
        StoryChallenge(title: "山海经", age: [.SixPlus]),
        StoryChallenge(title: "风雅颂", age: [.SixPlus]),
        StoryChallenge(title: "四大名著", age: [.SixPlus], isLocked: false, stories: [
            Story(title: "石猴出世", parentTitle: "四大名著", videoUrl: Bundle.main.url(forResource: "西游记", withExtension: "mp4"), keyWord: "裂开", targetFigure: "孙悟空", targetColor: Color(red: 0.93, green: 0.46, blue: 0.18), welcomeSound: "A-仙石发生了什么", actionTintSound: "A-蹦出什么", soundUrl: "A-石猴出世"), // 橙
            Story(title: "美猴王学艺", parentTitle: "四大名著"),
            Story(title: "龙宫寻宝", parentTitle: "四大名著"),
            Story(title: "大闹天宫", parentTitle: "四大名著")
        ], figures: ["唐僧", "土地公公", "孙悟空", "沙和尚", "猪八戒", "佛祖"])
    ]

    mutating func ChooseChallenge(challenge: StoryChallenge) {
        for index in challenges.indices {
            challenges[index].isSelected = challenge.id == challenges[index].id
        }
    }

    mutating func ChooseStory(story: Story) {
        for challengeIndex in challenges.indices {
            for storyIndex in challenges[challengeIndex].stories.indices {
                challenges[challengeIndex].stories[storyIndex].isSelected = false
            }
        }
        
        for (challengeIndex, challenge) in challenges.enumerated() {
            if let storyIndex = challenge.stories.firstIndex(where: { $0.id == story.id }) {
                challenges[challengeIndex].isSelected = true
                challenges[challengeIndex].stories[storyIndex].isSelected = true
                return
            }
        }
        print("[StoryGameModel] 选择故事失败: 未找到ID为'\(story.id)'的故事")
    }
    
    mutating func FinishStory() {
        if let challengeIndex = indexOfSelectedChallenge, let storyIndex = indexOfSelectedStory {
            challenges[challengeIndex].stories[storyIndex].isFinished = true
        }
    }
}

// MARK: - 数据模型
struct Story: Identifiable {
    let id = UUID().uuidString
    // StoryCell标题
    let title: String
    // Story的主题
    let parentTitle: String
    // 是否完成
    var isFinished = false
    // 是否是当前被选中的故事
    var isSelected = false
    // 故事视频资源URL
    private(set) var videoUrl: URL?
    // 故事语音关键词口令
    var keyWord = ""
    // 故事动物
    var targetFigure = ""
    // 搭配颜色
    var targetColor = Color(red: 0.93, green: 0.46, blue: 0.18) // 橙
    // 游戏开始提示音
    var welcomeSound = ""
    // 游戏动作提示音
    var actionTintSound = ""
    // 故事语音资源
    var soundUrl = ""
}

struct StoryChallenge: Identifiable {
    internal let id = UUID().uuidString
    // 板块标题和图片
    let title: String
    // 板块年龄段
    let age: [Ages]
    // 是否已经解锁
    var isLocked = true
    // 是否被选中
    var isSelected = false
    // 子Stories
    var stories = [Story]()
    // 图形选择
    var figures = [String]()
}
