
import SwiftUI
import AVKit

struct draft: View {
    
    @State var voicePlayer: AVAudioPlayer!
    @State var isPlaying = false
    var soundName = "故事闯关涂鸦"
    
    var body: some View {
        Button {
            if isPlaying {
                voicePlayer.stop()
                isPlaying = false
            } else {
                playSound(sound: soundName)
            }
        } label: {
            Image(K.AppIcon.speaker)
                .renderingMode(.template)
                .resizable()
                .frame(width: 45, height: 45)//图片默认大小是64x64
                .foregroundColor(K.AppColor.ThemeButtonColor)
        }
    }
    
    /// 播放提示音
    func playSound(sound: String) {
        if sound == "" { return }
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            voicePlayer = try AVAudioPlayer(contentsOf: url)
            voicePlayer.play()
            isPlaying = true
        } catch let error {
            print(error)
        }
    }
}


struct draft_Previews: PreviewProvider {
    static var previews: some View {
        draft()
    }
}
