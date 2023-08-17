
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
    
    var body: some View {
        ZStack {
            // background
            Background()
            
            // content
            HStack {
                functionButtons
                videoSection
                ColorChosenSection(selectedColor: $selectedColor)
                animalChosenSection
            }
            .padding(30)
            // 完成游戏弹窗
            ZStack {
                if finishedGame {
                    VictoryView(path: $path)
                        .ignoresSafeArea()
                        .zIndex(3)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            vm.chooseStory(story: story)
            vm.playSound(sound: story.welcomeSound)
            isPlayingVoice = true
        }
    }
}

// MARK: - Components
extension StoryView {
    // 最左侧按键区
    var functionButtons: some View {
        VStack {
            BackButton()
            Spacer()
            // 播放故事语音
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
                Image(K.AppIcon.storySpeaker)
            }
        }
    }
    // 视频区域
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
                        .frame(maxHeight: 537)
                        .padding(.horizontal)
                        .disabled(true) // 隐藏视频控件
                    
                }
            }
            Spacer()
            //voiceButton
        }
        .onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
        .onTapGesture {
            playFirstAV()
            vm.playSound(sound: story.actionTintSound)
        }
        
    }
    // 语音识别按钮
    var voiceButton: some View {
        VStack(spacing: 50) {
            Text(voiceText)
                .font(.system(size: 25).bold())
            SwiftSpeech.RecordButton()
                .tint(selectedColor)
                .swiftSpeechRecordOnHold(locale: Locale(identifier: "zh-CN"))
                .onRecognizeLatest(update: $voiceText)
                .onChange(of: voiceText) { newValue in
                    // 当检测到语音识别到故事关键词时，播放第一段动画
                    if newValue.contains(story.keyWord) {
                        playFirstAV()
                        vm.playSound(sound: story.actionTintSound)
                    }
                }
                .disabled(isPlayingVideo)
        }
    }

    // 动物选择区
    var animalChosenSection: some View {
//        ScrollView {
            VStack(spacing: 20) {
                ForEach(K.AppIcon.animals, id: \.self) { animal in
                    AnimalsCell(animal: animal, selectedAnimal: $selectedAnimals, selectedColor: $selectedColor, hasFinishedPlacingAnimal: $hasFinishedPlacingAnimal)
                }
            }
       // }

        
        .onChange(of: hasFinishedPlacingAnimal) { newValue in
            if newValue == true && selectedAnimals == story.targetAnimal && selectedColor == story.targetColor {
                vm.playVideo()
                vm.playSound(sound: story.finishGameSound)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    vm.finishedGame()
                    finishedGame = true//
                }
            }
        }
    }
    
}

// MARK: - Functions
extension StoryView {
    // 语音控制播放第一段动画
    func playFirstAV() {
        vm.playVideo()
        // 禁止语音按钮，播放视频提示音
        isPlayingVideo = true
        // 异步延迟
        delay(by: story.pauseSeconds) {
            voiceText = "按住按钮说话"
            vm.stopVideo()
            isPlayingVideo = false
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
