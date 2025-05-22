import Foundation
import AVKit

class SpeakingGameVM: ObservableObject{
    var comics: [UIImage] {
        self.model.comics
    }
    /// 播放故事视频
    @Published var videoPlayer = AVPlayer()
    // 游戏模组
    @Published var model = createSpeakingGame()
    /// 能力分析得分
    var scores: [Int] {
        self.model.scores
    }
    
    func loaComics() {
        self.model.loadComics()
    }

    func deleteComics(at index: Int) {
        self.model.deleteComics(at: index)
    }

    private var timer: Timer?
    private(set) var seconds = 0.0
    
    private static func createSpeakingGame() -> SpeakingGameModel {
        SpeakingGameModel()
    }
    
    func initVideoPlayer(story: Story) {
        if let videoURL = story.url {
            self.videoPlayer = AVPlayer(url: videoURL)
        } else {
            self.videoPlayer = AVPlayer()
        }
    }

    func playStory(story: String) {
        self.videoPlayer.play()
        AudioManager.shared.playSound(story)
    }
    
    func stopStory() {
        self.videoPlayer.pause()
        AudioManager.shared.stopSound()
    }
    
    func startDecording() {
        self.timer = Timer(timeInterval: 1, repeats: true) { _ in
            self.seconds += 1
        }
        RunLoop.current.add(self.timer!, forMode: .default)
    }

    func stopDecording() {
        self.timer?.invalidate()
        self.timer = nil
    }

    func calculateScore(text: String) {
        self.model.analyzeSpeech(text: text, duration: Int(self.seconds))
    }
}

