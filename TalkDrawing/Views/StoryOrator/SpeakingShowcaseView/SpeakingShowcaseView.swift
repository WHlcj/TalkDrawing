
import SwiftUI
import AVKit
import SwiftSpeech

struct SpeakingShowcaseView: View {
    
    // App路由导航
    @Binding var path: NavigationPath
    // SpeakingGameVM
    @ObservedObject var vm: SpeakingGameVM
    // 是否正在播放故事
    @State var isPlaying = false
    // 语音文本
    @State var voiceText = ""
    // 正在录音
    @State var isDecording = false
    // 录音成功
    @State var finishedDecording = false
    // 弹窗
    @State var showSheets = false
    // 弹出语言能力分析报告
    @State var showResult = false
    // 故事资源
    @State var story: Story?
    // 连环画资源
    @State var image: Image?
    
    var body: some View {
        ZStack {
            ThemeBackground()
            
            VStack {
                ThemeNavigationBar(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家")
                    .padding(.bottom, 20)
                Spacer()
                HStack {
                    mediaSection
                    functionButtons
                }
                Spacer()
            }
            
            if showSheets {
                InfoSheet(showSheets: $showSheets)
                    .zIndex(2)
            }
            if self.showResult {
                LanguageTrainingBaseView(scores: vm.scores)
            }
        }
        .onAppear {
            if story != nil {
                vm.initVideoPlayer(story: story!)
            }
        }
    }
}

extension SpeakingShowcaseView {
    /// 媒体区
    var mediaSection: some View {
        VStack {
            if story != nil {
                VideoPlayer(player: vm.videoPlayer)
                    .aspectRatio(144.0/81.0, contentMode: .fit)
                    .padding(.horizontal)
                    .disabled(true) // 隐藏视频控件
                    .background(
                        Rectangle()
                            .fill(.white)
                            .opacity(0.4)
                    )
            } else {
                image!
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
            SwiftSpeech.RecordButton()
                .swiftSpeechToggleRecordingOnTap(locale: Locale(identifier: "zh-CN"))
                .onRecognizeLatest(update: $voiceText)
                .scaleEffect(0.8)
                .disabled(!isDecording)
        }
        .onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
    /// 功能按键区
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
    /// 播放故事
    private func playStory() {
        if story != nil {
            if isPlaying {
                vm.stopStory()
                isPlaying = false
            } else {
                vm.playStory(story: story!.storySpeaker)
                isPlaying = true
            }
        }
    }
    /// 分享乐园
    private func startDecording() {
        if !isDecording {
            voiceText = "" // 开始录音前设置当前文本为空
            isDecording = true // 开启录音
            vm.startDecording() // 开始计时
            finishedDecording = false // 重置finishedDecording属性
        } else {
            isDecording = false // 停止录音
            vm.calculateScore(text: voiceText) // 根据录音文本计算分数
            vm.stopDecording() // 停止计时
            finishedDecording = true  // 完成录音，可以生成语言能力报告
        }
    }
    /// 查看语言分析报告
    private func getResult() {
        if finishedDecording {
            showResult = true
        } else {
            showSheets = true
        }
    }
}



struct SpeakingShowcaseView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        @State var vm = SpeakingGameVM()
        SpeakingShowcaseView(path: $path, vm: vm, story: Story(title: "门前大桥下", parentTitle: "经典儿歌", url: Bundle.main.url(forResource: "门前大桥下", withExtension: "mp4")))
    }
}
