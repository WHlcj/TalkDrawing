
// TODO:
// 1.修复scrollView的内容视图无法拖拽出来的情况

import SwiftUI
import AVKit
import SwiftSpeech

struct StoryView: View {
    // App导航路由
    @Binding var path: NavigationPath
    // 故事闯关控制VM
    @ObservedObject var vm: StoryGameVM
    // 选中的故事
    let story: Story
    // 颜色选择
    @State private var selectedColor = Color.green
    // 动物选择
    @State private var selectedAnimals = ""
    // 语音文本识别与关键词检测
    @State private var voiceText = "按住按钮说话"
    // 语音助手控制
    @State private var isPlayingVideo = false
    // 是否上色并放置动物
    @State private var hasFinishedPlacingAnimal = false
    // 完成游戏弹出结算画面
    @State private var finishedGame = false
    // 是否正在播放声音
    @State private var isPlayingVoice = false
    // 是否识别完关键词
    @State private var recognizedKey = false
    
    var body: some View {
        ZStack {
            // background
            Background()
            
            // content
            HStack {
                functionButtons
                videoSection
                ColorChosenSection(selectedColor: $selectedColor)
                figureChosenSection
            }
            .padding(30)
            // 完成游戏弹窗
            if finishedGame {
                VictoryView(path: $path, soundName: "A-完成")
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // 加载故事资源
            vm.chooseStory(story: story)
            // 播放故事
            if story.welcomeSound != "" {
                vm.playSound(sound: story.welcomeSound)
            } else {
                vm.playSound(sound: story.actionTintSound)
                recognizedKey = true
            }
        }
        .onDisappear {
            vm.stopSound()
        }
    }
}

// MARK: - Components
extension StoryView {
    /// 左侧按键区
    var functionButtons: some View {
        VStack {
            BackButton()
            Spacer()
            speakerButton
        }
        .padding(.vertical)
    }
    /// 播放故事语音
    var speakerButton: some View {
        Button {
            if isPlayingVoice {
                vm.stopSound()
                isPlayingVoice = false
            } else {
                // 点击播放故事
                vm.playSound(sound: story.storySpeaker)
                isPlayingVoice = true
            }
        } label: {
            Image(K.AppIcon.speaker)
        }
    }
    /// 视频语音交互区域
    var videoSection: some View {
        VStack {
            ZStack {
                // background
                Rectangle()
                    .fill(.white)
                    .opacity(0.4)
                
                // content
                VStack {
                    VideoPlayer(player: vm.videoPlayer)
                        .aspectRatio(144.0/81.0, contentMode: .fit)
                        .padding(.horizontal)
                        .disabled(true) // 隐藏视频控件
                }
            }
            Spacer()
            voiceButton
        }
        .onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
    // 语音识别按钮
    var voiceButton: some View {
        VStack(spacing: 40) {
            Text(voiceText)
                .font(.system(size: 20).bold())
            SwiftSpeech.RecordButton()
                .swiftSpeechRecordOnHold(locale: Locale(identifier: "zh-CN"))
                .onRecognizeLatest(update: $voiceText)
                .onChange(of: voiceText) { newValue in
                    // 当检测到语音识别到故事关键词时，播放第一段动画
                    if newValue.contains(story.keyWord) && recognizedKey != true {
                        recognizedKey = true
                        playFirstAV()
                        vm.playSound(sound: story.actionTintSound)
                    }
                }
                .scaleEffect(0.8)
                .disabled(isPlayingVideo)
        }
        .padding(.bottom)
    }
    // 动物选择区
    var figureChosenSection: some View {
        VStack(spacing: 20) {
            ForEach(vm.selectedChallenge!.figures, id: \.self) { figure in
                FiguresCell(figure: figure, selectedFigure: $selectedAnimals, selectedColor: $selectedColor, hasFinishedPlacingAnimal: $hasFinishedPlacingAnimal)
            }
        }
        .onChange(of: hasFinishedPlacingAnimal) { newValue in
            if newValue == true {
                if recognizedKey {
                    checkFinishGame()
                }
            }
        }
    }
}

// MARK: - Functions
extension StoryView {
    /// 语音控制播放第一段动画
    func playFirstAV() {
        vm.playVideo()
        // 禁止语音按钮，播放视频提示音
        isPlayingVideo = true
        // 异步延迟
        delay(by: 1) {
            voiceText = "按住按钮说话"
            vm.stopVideo()
            isPlayingVideo = false
        }
    }
    /// 完成游戏检测
    func checkFinishGame() {
        if selectedAnimals == story.targetFigure && selectedColor == story.targetColor {
            if recognizedKey {
                vm.playVideo()
                delay(by: 3) {
                    vm.finishedGame()
                    finishedGame = true
                }
            }
        } else {
            vm.playSound(sound: "A-错误提醒")
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var vm = StoryGameVM()
        @State var path = NavigationPath()
        let story = Story(title: "门前大桥下", parentTitle: "童话寓言")
        StoryView(path: $path, vm: vm, story: story)
    }
}
