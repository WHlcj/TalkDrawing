
import Foundation
import UIKit
import AVFAudio

class DrawingGameVM: ObservableObject {
    static let shared = DrawingGameVM()
    /// 游戏模组
    @Published var model = createDrawingGame()
    
    private static func createDrawingGame() -> DrawingGameModel {
        DrawingGameModel()
    }
    /// 画板
    var canvas = ["何时", "何地", "何人", "何事"]
    /// 图片链接
    @Published var img = ""
    /// 信号量
    private var semaphore = DispatchSemaphore(value: 0)
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
