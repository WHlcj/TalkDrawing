
import Foundation

// 故事闯关式涂鸦的Stroy
struct Story {
    let id = UUID().uuidString
    // StoryCell标题
    let title: String
    // Story的主题
    let parentTitle: String
    // 是否完成
    let isFinished = false
    
//    static let stories = [
//        Story(title: "门前大桥下", parentTitle: "经典儿歌"),
//        Story(title: "两只老虎", parentTitle: "经典儿歌"),
//        Story(title: "小燕子", parentTitle: "经典儿歌"),
//        Story(title: "丢手绢", parentTitle: "经典儿歌"),
//    ]

}
