
import Foundation
import PencilKit

class DrawingGameVM: ObservableObject {
    
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


    
    func fetchImage(text: String) {
        print("调用fetchImage成功")
        oldImg = img
        model.performAskImage(text: text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.refreshImage()
        }
    }
    
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
    
    
}
