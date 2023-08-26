
import Foundation
import SwiftUI

// 年龄分段
enum Ages: String {
    case zeroToThree
    case foreToSix
    case SenvenPlus
}

struct StoryGameModel {
    // 当前选择的挑战的索引
    var indexOfSelectedChallenge: Int? {
        get {
            challenges.firstIndex(where: { $0.isSelected == true })
        }
    }
    // 当前选择的故事的索引
    var indexOfSelectedStory: Int? {
        get {
            challenges[indexOfSelectedChallenge ?? 0].stories.firstIndex(where: { $0.isSelected == true })
        }
    }
    // 当前游戏主要内容
    private(set) var challenges = [
        StoryChallenge(title: "经典儿歌", age: [.zeroToThree, .foreToSix, .SenvenPlus], isLocked: false, stories: [
            Story(title: "门前大桥下", parentTitle: "经典儿歌", url: Bundle.main.url(forResource: "门前大桥下", withExtension: "mp4"), pauseSeconds: 2.0, keyWord: "桥", targetAnimal: "duck", welcomeSound: "A-河流上有什么", actionTintSound: "A-拖拽", errorTintSound: "A-错误提醒", finishGameSound: "A-完成", storySpeaker: "A-数鸭子"),
            Story(title: "两只老虎", parentTitle: "经典儿歌"),
            Story(title: "小燕子", parentTitle: "经典儿歌"),
            Story(title: "丢手绢", parentTitle: "经典儿歌"),
        ]),
        StoryChallenge(title: "童话寓言", age: [.zeroToThree, .foreToSix, .SenvenPlus], isLocked: false),
        StoryChallenge(title: "国学诗词", age: [.zeroToThree, .foreToSix, .SenvenPlus]),
        StoryChallenge(title: "传统文化", age: [.zeroToThree, .foreToSix, .SenvenPlus]),
        StoryChallenge(title: "自然百科", age: [.zeroToThree, .foreToSix, .SenvenPlus]),
        StoryChallenge(title: "历史人文", age: [.foreToSix, .SenvenPlus]),
        StoryChallenge(title: "地理名胜", age: [.foreToSix, .SenvenPlus]),
        StoryChallenge(title: "国外绘本", age: [.foreToSix, .SenvenPlus]),
        StoryChallenge(title: "山海经", age: [.SenvenPlus]),
        StoryChallenge(title: "风雅颂", age: [.SenvenPlus]),
        StoryChallenge(title: "四大名著", age: [.SenvenPlus])
    ]
    // StoryChallengeView的模版选择
    mutating func ChooseChallenge(challenge: StoryChallenge) {
        for index in challenges.indices {
            challenges[index].isSelected = challenge.id == challenges[index].id
        }
    }
    // StoriesListView的故事选择
    mutating func ChooseStory(story: Story) {
        if let challengeIndex = indexOfSelectedChallenge {
            for index in challenges[challengeIndex].stories.indices {
                challenges[challengeIndex].stories[index].isSelected = story.id == challenges[challengeIndex].stories[index].id
            }
        } else {
            //print("选择故事失败")
        }
    }
    // 完成故事游戏
    mutating func FinishStory() {
        if let challengeIndex = indexOfSelectedChallenge, let storyIndex = indexOfSelectedStory {
            challenges[challengeIndex].stories[storyIndex].isFinished = true
        }
    }
}

// MARK: - 数据模型
/// 故事闯关式涂鸦的Stroy
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
    private(set) var url: URL?
    // 故事视频暂停点
    var pauseSeconds = 4.0
    // 故事语音关键词口令
    var keyWord = ""
    // 故事动物
    var targetAnimal = ""
    // 游戏开始提示音
    var welcomeSound = ""
    // 游戏动作提示音
    var actionTintSound = ""
    // 游戏错误提示音
    var errorTintSound = ""
    // 游戏完成提示音
    var finishGameSound = ""
    // 故事语音
    var storySpeaker = ""
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
}
