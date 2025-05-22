
import SwiftUI
import AVFAudio

struct VictoryView: View {
    var soundName = ""
    @State var isPlaying = false
    @State var voicePlayer: AVAudioPlayer!
    var starNumber = 1
    var title = "下一关"
    var active: (() -> Void)?
    
    var body: some View {
        ZStack{
            TDThemeNotificationBackground()
            
            VStack(spacing: 50) {
                Image(K.AppIcon.finishGame)
                starsView
                functionButtons
            }
            .onAppear {
                playSound(soundName)
                isPlaying = true
            }
            .onDisappear {
                if isPlaying {
                    self.voicePlayer.stop()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension VictoryView {
    var starsView: some View {
        HStack {
            ForEach(1...self.starNumber, id: \.self) { item in
                Image(K.AppIcon.star)
                    .resizable()
                    .frame(width: 150, height: 150)
            }
        }
        .padding(.bottom, 50)
    }

    var functionButtons: some View {
        HStack(spacing: 100) {
            VictoryItem(icon: K.AppIcon.backHome, title: "主页") {
                NavigationManager.shared.goToRoot()
            }

            VictoryItem(icon: K.AppIcon.leftArrow, title: "返回") {
                NavigationManager.shared.goBack(count: 2)
            }
            
            if let action = active {
                VictoryItem(icon: K.AppIcon.rightArrow, title: self.title) {
                    action()
                }
            }
            
        }
    }
    
    struct VictoryItem: View {
        let icon: String
        let title: String
        var active: (() -> Void)?
        
        var body: some View {
            Button {
                if let action = active {
                    action()
                }
            } label: {
                VStack {
                    Image(icon)
                    Text(title)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }
        }
    }

    func playSound(_ sound: String) {
        if sound == "" { return }
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            self.voicePlayer = try AVAudioPlayer(contentsOf: url)
            self.voicePlayer.play()
            self.isPlaying = true
        } catch let error {
            print("[VictoryView] play sound failed with error: \(error)")
        }
    }
}


struct VictoryView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        VictoryView(starNumber: 3)
    }
}
