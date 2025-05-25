import SwiftUI
import AVKit

struct SpeakingShowcaseView: View {
    @State var isPlayingVideo = false
    @State var voiceText = ""
    // 正在录音
    @State var isDecording = false
    // 录音成功
    @State var finishedDecording = false
    @State var showSheets = false
    
    var body: some View {
        ZStack {
            TDThemeBackground()
            
            VStack {
                TDThemeNavigationBar(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家")
                    .padding(.bottom, 20)
                Spacer()
                HStack {
                    mediaSection
                    functionButtons
                }
                Spacer()
            }
            
            if showSheets {
                TDInfoSheet(
                    isPresented: $showSheets,
                    title: "提示",
                    message: "请先完成亲子分享乐园再查看语言能力报告",
                    buttonText: "好的"
                )
                .zIndex(2)
            }
        }
    }
}

extension SpeakingShowcaseView {
    /// 媒体区
    var mediaSection: some View {
        VStack {
            if SpeakingGameVM.shared.selectedStory != nil {
                VideoPlayer(player: VideoManager.shared.player)
                    .aspectRatio(144.0/81.0, contentMode: .fit)
                    .padding(.horizontal)
                    .disabled(true) // 隐藏视频控件
                    .background(
                        Rectangle()
                            .fill(.white)
                            .opacity(0.4)
                    )
            } else {
                Image(uiImage: SpeakingGameVM.shared.selectedComic!)
                    .resizable()
                    .aspectRatio(144.0/81.0, contentMode: .fit)
                    .padding(.horizontal)
                    .background(
                        Rectangle()
                            .fill(.white)
                            .opacity(0.8)
                    )
            }
            Text(isDecording ? "正在录音" : " ")
                .font(.system(size: 20))
                .padding(.vertical)
            TDVoiceRecordButton(
                mode: .tapToToggle,
                recognizedText: $voiceText,
            )
            .disabled(!isDecording)
        }
    }

    var functionButtons: some View {
        VStack(spacing: 50) {
            CustomButton(title: "故事情节回顾") { playStory() }
            CustomButton(title: isDecording ? "停止录音" : "亲子分享乐园") { startDecording() }
            CustomButton(title: "语言能力分析") { getResult() }
        }
        .padding(.horizontal)
    }

    struct CustomButton: View {
        let title: String
        var active: (() -> Void)?
        
        var body: some View {
            VStack {
                Button {
                    if let action = active {
                        action()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(K.AppColor.ThemeColor)
                        .frame(width: 200, height: 70)
                        .blur(radius: 2)
                        .overlay(
                            Text(title)
                                .font(.system(size: 25))
                                .foregroundColor(.black.opacity(0.8))
                        )
                }
            }
        }
    }
}

// MARK: - Functions
extension SpeakingShowcaseView {
    private func playStory() {
        if let story = SpeakingGameVM.shared.selectedStory {
            if isPlayingVideo {
                VideoManager.shared.pause()
                AudioManager.shared.stopSound()
                isPlayingVideo = false
            } else {
                VideoManager.shared.play()
                AudioManager.shared.playSound(story.soundUrl)
                isPlayingVideo = true
            }
        }
    }
    /// 分享乐园
    private func startDecording() {
        if !isDecording {
            voiceText = ""
            isDecording = true
            SpeakingGameVM.shared.startDecording()
            finishedDecording = false
        } else {
            isDecording = false
            SpeakingGameVM.shared.calculateScore(text: voiceText)
            SpeakingGameVM.shared.stopDecording()
            finishedDecording = true
        }
    }
    /// 查看语言分析报告
    private func getResult() {
        if finishedDecording {
            NavigationManager.shared.navigateTo("LanguageTrainingBaseView")
        } else {
            showSheets = true
        }
    }
}



struct SpeakingShowcaseView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakingGameVM.shared.selectedStory = StoryGameVM.shared.challenges[0].stories[0]
        return SpeakingShowcaseView()
    }
}
