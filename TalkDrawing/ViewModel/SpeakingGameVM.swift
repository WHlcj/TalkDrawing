
import Foundation
import AVKit

class SpeakingGameVM: ObservableObject{
    
    /// 连环画资源
    var comics: [UIImage] {
        model.comics
    }
    /// 播放故事视频
    @Published var videoPlayer = AVPlayer()
    /// 播放故事
    @Published var voicePlayer = AVAudioPlayer()
    // 游戏模组
    @Published var model = createSpeakingGame()
    /// 能力分析得分
    var scores: [Int] {
        model.scores
    }
    
    /// 加载连环画
    func loaComics() {
        model.loadComics()
    }
    
    /// 删除连环画
    func deleteComics(at index: Int) {
        model.deleteComics(at: index)
    }
    
    
    
    // 计时器
    private var timer: Timer?
    private(set) var seconds = 0.0
    
    private static func createSpeakingGame() -> SpeakingGameModel {
        SpeakingGameModel()
    }
    
    // MARK: - 故事情节回顾
    /// 若为我的绘本，进入SpeakingShowcaseView后初始化视频
    func initVideoPlayer(story: Story) {
        // 获取资源文件的 URL
        if let videoURL = story.url {
            videoPlayer = AVPlayer(url: videoURL)
        } else {
            self.videoPlayer = AVPlayer()
        }
    }
    /// 故事回顾
    ///  同时播放故事视频和语音
    func playStory(story: String) {
        videoPlayer.play()
        playSound(sound: story)
    }
    func stopStory() {
        videoPlayer.pause()
        voicePlayer.stop()
    }
    /// 播放提示音
    private func playSound(sound: String) {
        if sound == "" { return }
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            voicePlayer = try AVAudioPlayer(contentsOf: url)
            voicePlayer.play()
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - 语言能力分析
    
    /// 开始计时
    func startDecording() {
        timer = Timer(timeInterval: 1, repeats: true) { _ in
            self.seconds += 1
        }
        RunLoop.current.add(timer!, forMode: .default)
    }
    /// 停止时间
    func stopDecording() {
        timer?.invalidate()
        timer = nil
    }
    /// 计算得分
    func calculateScore(text: String) {
        model.calculateScore(text: text, second: Int(seconds))
    }

}

