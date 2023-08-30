
import Foundation
import PencilKit
import AVFAudio

class DrawingGameVM: ObservableObject {
    
    /// 播放故事提示音
    @Published var voicePlayer = AVAudioPlayer()
    // 游戏模组
    @Published var model = createDrawingGame()
    
    private static func createDrawingGame() -> DrawingGameModel {
        DrawingGameModel()
    }
    // 画板
    var canvas: [String] {
        model.canvas
    }
    // 图片链接
    @Published var img = ""
    // 二次请求
    private var oldImg = ""
    
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
    /// 文字请求图片
    func fetchImage(text: String) {
        oldImg = img
        model.performAskImage(text: text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.refreshImage()
        }
    }
    /// 持续刷新图片请求
    private func refreshImage() {
        if model.img == "" || oldImg == model.img {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshImage()
            }
        } else {
            self.img = model.img
            print("当前的img为: \(img)")
        }
    }
    /// 保存连环画到软件文件内
    func saveComics(images: [UIImage]) {
        model.saveComics(images: images)
    }
    
    
}
