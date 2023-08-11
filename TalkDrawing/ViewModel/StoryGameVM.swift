
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
    
    var challenges: [StoryChallenge] {
        model.challenges
    }
    
    private var videoURL: URL?
    
    init() {
    }
    
    // MARK: - 游戏交互控制
    // 选择挑战模块
    func chooseChallenge(challenge: StoryChallenge) {
        model.ChooseChallenge(challenge: challenge)
    }
    // 选择故事
    func chooseStory(story: Story) {
        model.ChooseStory(story: story)
        initVideoPlayer()
    }
    // 进入故事模块
    func initVideoPlayer() {
        // 获取资源文件的 URL
        if let challengeIndex = model.indexOfSelectedChallenge, let storyIndex = model.indexOfSelectedStory {
            if let videoURL = challenges[challengeIndex].stories[storyIndex].url {
                player = AVPlayer(url: videoURL)
                player.pause()
            } else {
                self.player = AVPlayer()
            }
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
