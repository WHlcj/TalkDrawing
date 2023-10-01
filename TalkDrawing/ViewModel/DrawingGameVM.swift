
import Foundation
import PencilKit
import AVFAudio

// TODO:
// 1. 修复运行时  @Published var voicePlayer: AVAudioPlayer!
//Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.  报错
class DrawingGameVM: ObservableObject {
    
    /// 播放故事提示音
    @Published var voicePlayer: AVAudioPlayer!
    /// 游戏模组
    @Published var model = createDrawingGame()
    
    private static func createDrawingGame() -> DrawingGameModel {
        DrawingGameModel()
    }
    /// 画板
    var canvas: [String] {
        model.canvas
    }
    /// 图片链接
    @Published var img = ""
    /// 信号量
    private var semaphore = DispatchSemaphore(value: 0)
    
    /// 播放音频
    func playVoice(_ sound: String?) {
        if sound == "" { return }
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            voicePlayer = try AVAudioPlayer(contentsOf: url)
            voicePlayer.play()
        } catch let error {
            print(error)
        }
    }
    /// 停止播放音频
    func stopVoice() {
        voicePlayer.stop()
    }
    /// 文字请求图片
    func fetchImage(text: String) {
        model.performAskImage(text: text, semaphore: semaphore)
        DispatchQueue.global().async {
            // 等待图片回传成功
            self.semaphore.wait()
            self.img = self.model.img
            print("当前的img为: \(self.img)")
        }
    }
    /// 保存连环画到软件文件内
    func saveComics(images: [UIImage]) {
        model.saveComics(images: images)
    }
}
