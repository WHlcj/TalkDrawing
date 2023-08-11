
import Foundation

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
            StoryGameModel.storyChallenges.firstIndex(where: { $0.isSelected == true })
        }
    }
    // 当前选择的故事的索引
    var indexOfSelectedStory: Int? {
        get {
            StoryGameModel.storyChallenges[indexOfSelectedChallenge ?? 0].stories.firstIndex(where: { $0.isSelected == true })
        }
    }
    
        // 当前游戏主要内容
        static private(set) var storyChallenges = [
            StoryChallenge(title: "经典儿歌", age: [.zeroToThree], isLocked: false, stories: [
                Story(title: "门前大桥下", parentTitle: "经典儿歌", url: Bundle.main.url(forResource: "门前大桥下", withExtension: "mp4"), pauseSeconds: 3),
                Story(title: "两只老虎", parentTitle: "经典儿歌"),
                Story(title: "小燕子", parentTitle: "经典儿歌"),
                Story(title: "丢手绢", parentTitle: "经典儿歌"),
            ]),
            StoryChallenge(title: "童话寓言", age: [.zeroToThree], isLocked: false),
            StoryChallenge(title: "国学诗词", age: [.foreToSix, .SenvenPlus]),
            StoryChallenge(title: "历史人文", age: [.foreToSix, .SenvenPlus]),
            StoryChallenge(title: "传统文化", age: [.foreToSix, .SenvenPlus]),
            StoryChallenge(title: "自然百科", age: [.foreToSix, .SenvenPlus]),
            StoryChallenge(title: "地理名胜", age: [.SenvenPlus]),
            StoryChallenge(title: "国外绘本", age: [.SenvenPlus])
        ]
    
    // StoryChallengeView的模版选择
    mutating func ChooseChallenge(challenge: StoryChallenge) {
        for index in StoryGameModel.storyChallenges.indices {
            StoryGameModel.storyChallenges[index].isSelected = challenge.id == StoryGameModel.storyChallenges[index].id
            //print("选择挑战板块成功, 当前选择的板块的index是\(indexOfSelectedChallenge!)")
        }
        print("当前的数据资料是\(StoryGameModel.storyChallenges[0].stories)")
    }

    // StoriesListView的故事选择
    mutating func ChooseStory(story: Story) {
        if let challengeIndex = indexOfSelectedChallenge {
            for index in StoryGameModel.storyChallenges[challengeIndex].stories.indices {
                StoryGameModel.storyChallenges[challengeIndex].stories[index].isSelected = story.id == StoryGameModel.storyChallenges[challengeIndex].stories[index].id
            }
            //print("选择故事成功, 当前选择的故事index是\(indexOfSelectedStory!)")
        } else {
            print("选择故事失败")
        }
    }
    
    // 完成故事游戏
    mutating func FinishStory() {
        if let challengeIndex = indexOfSelectedChallenge, let storyIndex = indexOfSelectedStory {
            StoryGameModel.storyChallenges[challengeIndex].stories[storyIndex].isFinished = true
            print("完成游戏成功!")
        }
    }
}

// MARK: - 数据模型
// 故事闯关式涂鸦的Stroy
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
    private(set) var url = Bundle.main.url(forResource: "", withExtension: "mp4")
    // 故事视频暂停点
    var pauseSeconds = 4
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
