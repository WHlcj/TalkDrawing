
import Foundation
import AVKit

class StoryGameVM: ObservableObject {
    
    // 媒体播放器
    /// 播放故事视频
    @Published var videoPlayer = AVPlayer()
    /// 播放故事提示音
    @Published var voicePlayer = AVAudioPlayer()
    // 游戏模组
    @Published var model = createStoryGame()
    
    private static func createStoryGame() -> StoryGameModel {
        StoryGameModel()
    }
    
    var challenges: [StoryChallenge] {
        model.challenges
    }
    
    private var videoURL: URL?
    
    // MARK: - 游戏交互控制
    // 选择挑战模块
    func chooseChallenge(challenge: StoryChallenge) {
        model.ChooseChallenge(challenge: challenge)
    }
    // 选择故事
    func chooseStory(story: Story) {
        model.ChooseStory(story: story)
        // 选择好故事后，初始化视频播放器
        initVideoPlayer()
    }
    // 进入故事模块
    func initVideoPlayer() {
        // 获取资源文件的 URL
        if let challengeIndex = model.indexOfSelectedChallenge, let storyIndex = model.indexOfSelectedStory {
            if let videoURL = challenges[challengeIndex].stories[storyIndex].url {
                videoPlayer = AVPlayer(url: videoURL)
            } else {
                self.videoPlayer = AVPlayer()
            }
          }
    }

    /// 播放动画
    func playVideo() {
        videoPlayer.play()
    }
    /// 停止播放动画
    func stopVideo() {
        videoPlayer.pause()
    }
    /// 停止播放声音
    func stopSound() {
        voicePlayer.stop()
    }
    /// 继续播放声音
    func playSound() {
        voicePlayer.play()
    }
    /// 播放提示音
    func playSound(sound: String) {
        if sound == "" { return }
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            voicePlayer = try AVAudioPlayer(contentsOf: url)
            voicePlayer.play()
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - 游戏完成控制
    func finishedGame() {
        playSound(sound: "A-完成")
        model.FinishStory()
    }

}
