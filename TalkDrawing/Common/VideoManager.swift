import Foundation
import AVKit

class VideoManager: ObservableObject {
    static let shared = VideoManager()
    
    @Published private(set) var player = AVPlayer()
    
    func initPlayer(url: URL?) {
        if let videoURL = url {
            self.player = AVPlayer(url: videoURL)
        } else {
            self.player = AVPlayer()
        }
    }
    
    func play() {
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
    }
    
    func stop() {
        self.pause()
        self.player.seek(to: .zero)
    }
}
