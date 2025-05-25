import Foundation
import UIKit
import AVFAudio

class DrawingGameVM: ObservableObject {
    static let shared = DrawingGameVM()
    @Published var model = createDrawingGame()
    
    private static func createDrawingGame() -> DrawingGameModel {
        DrawingGameModel()
    }

    var canvas = ["何时", "何地", "何人", "何事"]

    @Published var imgUrl = ""
    private var semaphore = DispatchSemaphore(value: 0)
    
    func fetchImage(text: String, style: String = "卡通画", resolution: String = "1024*1024") {
        self.imgUrl = ""
        model.performAskImage(text: text, semaphore: semaphore)
        DispatchQueue.global().async { [weak self] in
            self?.semaphore.wait()
            if let self = self {
                let newImgUrl = self.model.imgUrl
                if let url = URL(string: newImgUrl) {
                    print("[DrawingGameVM] URL 有效性检查通过: \(url)")
                    DispatchQueue.main.async {
                        self.imgUrl = newImgUrl
                        print("[DrawingGameVM] 当前的img为: \(self.imgUrl)")
                    }
                } else {
                    print("[DrawingGameVM] 无效的 URL: \(newImgUrl)")
                }
            }
        }
    }

    func saveComics(images: [UIImage]) {
        model.saveComics(images: images)
    }
}
