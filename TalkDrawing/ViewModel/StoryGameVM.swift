
import Foundation
import AVKit

class StoryGameVM: ObservableObject {
    
    @Published var videoPlayer = AVPlayer()
    @Published var voicePlayer = AVAudioPlayer()
    @Published var model = createStoryGame()
    
    private static func createStoryGame() -> StoryGameModel {
        StoryGameModel()
    }
    
    var challenges: [StoryChallenge] {
        model.challenges
    }
    
    var selectedChallenge: StoryChallenge?
    
    private var videoURL: URL?
    
    // MARK: - 游戏交互控制
    func chooseChallenge(challenge: StoryChallenge) {
        model.ChooseChallenge(challenge: challenge)
        selectedChallenge = challenge
    }
    
    func chooseStory(story: Story) {
        model.ChooseStory(story: story)
        initVideoPlayer()
    }
    // 进入故事模块
    func initVideoPlayer() {
        // 获取资源文件的 URL
        if let challengeIndex = model.indexOfSelectedChallenge, let storyIndex = model.indexOfSelectedStory {
            if let videoURL = challenges[challengeIndex].stories[storyIndex].url {
                self.videoPlayer = AVPlayer(url: videoURL)
                print("[StoryGameVM] videoPlayer 资源初始化为 \(videoURL)")
            } else {
                self.videoPlayer = AVPlayer()
                print("[StoryGameVM] videoPlayer 资源初始化为 nil")
            }
        }
    }
    
    func playVideo() {
        videoPlayer.play()
    }
    
    func stopVideo() {
        videoPlayer.pause()
    }
    
    func stopSound() {
        voicePlayer.stop()
    }
    
    func playSound(_ sound: String) {
        if sound == "" {
            voicePlayer.play()
            return
        }
        
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            voicePlayer = try AVAudioPlayer(contentsOf: url)
            voicePlayer.play()
        } catch let error {
            print(error)
        }
    }
    
    func finishedGame() {
        model.FinishStory()
    }
    
}
