import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    @Published private(set) var isPlaying = false
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(_ sound: String) {
        if self.isPlaying {
            self.stopSound()
            return
        }
        if sound.isEmpty { return }
        
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
            print("[AudioManager] 找不到音频文件: \(sound)")
            return
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.play()
            self.isPlaying = true
        } catch let error {
            print("[AudioManager] 播放音频失败: \(error)")
        }
    }
    
    func stopSound() {
        self.audioPlayer?.stop()
        self.isPlaying = false
    }
}
