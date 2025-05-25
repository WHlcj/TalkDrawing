import Foundation
import UIKit

class SpeakingGameVM: ObservableObject {
    static let shared = SpeakingGameVM()
    @Published var model = createSpeakingGame()
    @Published private(set) var comics: [UIImage] = []
    
    var selectedStory: Story?
    var selectedComic: UIImage?
    
    func chooseStory(_ story: Story) {
        self.selectedComic = nil
        self.selectedStory = story
        VideoManager.shared.initPlayer(url: story.videoUrl)
    }
    
    func chooseComic(_ comic: UIImage) {
        self.selectedStory = nil
        self.selectedComic = comic
    }

    /// 能力分析得分
    var scores: [Int] {
        self.model.scores
    }
    
    func loadComics() {
        self.model.loadComics()
        self.comics = self.model.comics
    }

    func deleteComics(at index: Int) {
        self.model.deleteComics(at: index)
        self.comics.remove(at: index)
    }

    private var timer: Timer?
    private(set) var seconds = 0.0
    
    private static func createSpeakingGame() -> SpeakingGameModel {
        SpeakingGameModel()
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

