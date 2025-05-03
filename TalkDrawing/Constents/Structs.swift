
import SwiftUI
import AVFoundation

struct ThemeBackground: View {
    var body: some View {
        Image("theme_background")
            .resizable()
            .ignoresSafeArea()
    }
}

struct ThemeCollectionBackGround: View {
    var body: some View {
        Rectangle()
            .fill(K.AppColor.ThemeColor)
            .opacity(0.3)
            .blur(radius: 5)
    }
}

struct ThemeNotificationBackground: View {
    var body: some View {
        K.AppColor.ThemeColor
            .opacity(0.3)
            .ignoresSafeArea()
    }
}

struct ThemeBackButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(K.AppIcon.backButton)
                .renderingMode(.template)
                .resizable()
                .frame(width: 65, height: 45)
                .foregroundColor(K.AppColor.ThemeColor)
        }
        .navigationBarBackButtonHidden(true)
    }
}

/// 主题通用导航栏
///
/// - Parameter image: 标题图标
/// - Parameter title: 标题内容和声音播放内容
struct ThemeNavigationBar: View {
    var image: String
    var title: String

    var body: some View {
        HStack {
            ThemeBackButton()
            Spacer()
            HomeItem(image: image, title: title)
            Spacer()
            SpeakingButton(soundName: title)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

///  功能介绍语音按钮
struct SpeakingButton: View {
    var soundName = ""
    @State var voicePlayer: AVAudioPlayer!
    @State var isPlaying = false
    
    var body: some View {
        Button {
            if isPlaying {
                self.voicePlayer.stop()
                self.isPlaying = false
            } else {
                self.playSound(soundName)
            }
        } label: {
            Image(K.AppIcon.speaker)
                .renderingMode(.template)
                .resizable()
                .frame(width: 45, height: 45)//图片默认大小是64x64
                .foregroundColor(K.AppColor.ThemeColor)
        }
        .onDisappear {
            if self.isPlaying {
                self.voicePlayer.stop()
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
            print(error)
        }
    }
}

/// 主要功能区下的标题栏
struct HomeItem: View {
    var image: String
    var title: String
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 35)
                .fill(K.AppColor.HomeViewItemBackgroundColor)
                .shadow(color: K.AppColor.HomeViewItemShadow, radius:3, x: 3, y: 6)
                .frame(width: 100, height: 100)
                .overlay {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(K.AppColor.HomeViewItemBackgroundCircleColor)
                        .frame(width: 95, height: 95)
                        .overlay {
                            Image(image)
                                .resizable()
                                .frame(width: image != "pencil" ? 85 : 65, height: image != "pencil" ? 85 : 65)
                        }
                }
                .padding(.trailing, 20)
            Text(title)
                .font(.system(size: 42).bold())
            
        }
    }
}
/// app的消息提醒弹窗
/// - parameter text: This is the title for the alert.
/// - parameter value: This is the binding value which control your alert presend.
struct TextAlert: View {
    var text: String
    @Binding var boolValue: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image("appicon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .cornerRadius(13)
                Text(text)
                    .foregroundColor(.black)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
            )
        }
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity.animation(.spring())))
        .padding(.bottom, 20)
    }
}
/// 强制录音界面
struct RecordingView: View {
    @State var audioRecorder: AVAudioRecorder!
    
    var body: some View {
        Color.clear
            .onAppear {
                startRecording()
            }
            .onDisappear {
                stopRecording()
            }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("test.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            
            print("开始录音")
        } catch {
            print("录音失败")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        
        print("停止录音")
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
