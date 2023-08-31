
import SwiftUI
import AVFAudio

struct VictoryView: View {
    
    @Environment(\.dismiss) var dismiss
    // App路由导航
    @Binding var path: NavigationPath
    
    // 语音播报
    var soundName = ""
    @State var isPlaying = false
    @State var voicePlayer: AVAudioPlayer!
    
    // 星星数量
    var number = 1
    // 按键文本
    var title = "下一关"
    // 按键触发动作
    var active: (() -> Void)?
    
    var body: some View {
        ZStack{
            // background
            K.AppColor.ThemeButtonColor
                .opacity(0.3)
                .ignoresSafeArea()
            
            // content
            VStack(spacing: 50) {
                // 完成啦
                Image(K.AppIcon.finishGame)
                // 星星
                stars
                // 三个功能按键
                functionButtons
            }
            .onAppear {
                playSound(sound: soundName)
                isPlaying = true
            }
            .onDisappear {
                if isPlaying {
                    voicePlayer.stop()
                }
            }
        }
        .ignoresSafeArea()
        .zIndex(3)
    }
}

// MARK: - Conponents
extension VictoryView {
    /// 星星数量
    var stars: some View {
        HStack {
            ForEach(1...number, id: \.self) { item in
                Image(K.AppIcon.star)
                    .resizable()
                    .frame(width: 150, height: 150)
            }
        }
        .padding(.bottom, 50)
    }
    /// 功能按钮区
    var functionButtons: some View {
        HStack(spacing: 100) {
            // 返回主页按钮
            VictoryItem(icon: K.AppIcon.backHome, title: "主页") {
                path.removeLast(path.count)
            }
            // 返回上一页按钮
            VictoryItem(icon: K.AppIcon.leftArrow, title: "返回") {
                dismiss()
            }
            if let action = active {
                // 功能按钮
                VictoryItem(icon: K.AppIcon.rightArrow, title: title) {
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
    /// 播放结算音频
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


struct VictoryView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        VictoryView(path: $path, number: 3)
    }
}
