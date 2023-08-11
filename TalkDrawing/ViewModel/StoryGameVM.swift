
import Foundation
import AVKit

class StoryGameVM: ObservableObject {
    
    // 媒体播放器
    @Published var player = AVPlayer()
    // 游戏模组
    @Published var model = createStoryGame()
    
    private static func createStoryGame() -> StoryGameModel {
        StoryGameModel()
    }
    
    private var videoURL = Bundle.main.url(forResource: "", withExtension: "mp4")!
    
    init() {
    }
    
    // MARK: - 游戏交互控制
    // 选择挑战模块
    func chooseChallenge(challenge: StoryChallenge) {
        model.ChooseChallenge(challenge: challenge)
        print("调用VM的模块选择成功")
    }
    // 选择故事
    func chooseStory(story: Story) {
        model.ChooseStory(story: story)
        print("调用VM的故事选择成功")
    }
    // 进入故事模块
    func initVideoPlayer() {
        // 获取资源文件的 URL
        if let challengeIndex = model.indexOfSelectedChallenge, let storyIndex = model.indexOfSelectedStory {
              videoURL = StoryGameModel.storyChallenges[challengeIndex].stories[storyIndex].url ?? Bundle.main.url(forResource: "", withExtension: "mp4")!
            print("获取视频资源成功")
            player = AVPlayer(url: videoURL)
          }
        
    }

    // 播放视频
    func playVideo() {
        player.play()
    }
    
    // 停止播放
    func stopVideo() {
        player.pause()
    }
    
    // MARK: - 游戏完成控制
    func finishedGame() {
        model.FinishStory()
    }

    
    
    
}
