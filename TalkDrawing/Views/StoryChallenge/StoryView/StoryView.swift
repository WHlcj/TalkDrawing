
// TODO:
// 1.修复scrollView的内容视图无法拖拽出来的情况

import SwiftUI
import AVKit
import SwiftSpeech

struct StoryView: View {
    @Binding var path: NavigationPath
    @ObservedObject var vm: StoryGameVM
    
    @State private var selectedColor = Color.green
    @State private var selectedAnimals = ""
    @State private var voiceText = "按住按钮说话"     // 语音文本识别与关键词检测
    @State private var isPlayingVideo = false
    @State private var gestureFlag = false          // 是否上色并放置动物
    @State private var isPlayingVoice = false
    @State private var recognizedKey = false        // 是否识别完关键词
    
    var body: some View {
        ZStack {
            ThemeBackground()
            
            HStack(spacing: 10) {
                videoSection
                colorChosenSection
                figureChosenSection
            }
            .padding()
        }
        .navigationDestination(for: String.self) { destination in
            if destination == "VictoryView" {
                VictoryView(path: $path, soundName: "A-完成")
            }
        }
        .onAppear {
            if self.vm.selectedStory!.welcomeSound != "" {
                self.vm.playSound(self.vm.selectedStory!.welcomeSound)
            } else {
                self.vm.playSound(self.vm.selectedStory!.actionTintSound)
                self.recognizedKey = true
            }
        }
        .onDisappear {
            self.vm.stopSound()
        }
    }
}

extension StoryView {
    var functionButtons: some View {
        HStack {
            ThemeBackButton()
            Spacer()
            Text("《\(self.vm.selectedStory!.title)》")
                .font(.system(size: 42).bold())
                .foregroundColor(K.AppColor.ThemeColor)
            speakerButton
            Spacer()
        }
        .padding(.vertical)
    }
    
    var speakerButton: some View {
        Button {
            if self.isPlayingVoice {
                self.vm.stopSound()
                self.isPlayingVoice = false
            } else {
                self.vm.playSound(self.vm.selectedStory!.storySpeaker)
                self.isPlayingVoice = true
            }
        } label: {
            Image(K.AppIcon.speaker)
                .frame(width: 40, height: 40)
                .foregroundColor(self.isPlayingVoice ? K.AppColor.ThemeColor : .blue)
        }
    }

    var videoSection: some View {
        VStack {
            functionButtons
            
            VideoPlayer(player: self.vm.videoPlayer)
                .aspectRatio(144.0/81.0, contentMode: .fit)
                .disabled(true) // 隐藏视频控件
            
            voiceButton
        }
        .onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }

    var voiceButton: some View {
        VStack {
            Text(voiceText)
                .font(.system(size: 20).bold())
            SwiftSpeech.RecordButton()
                .swiftSpeechRecordOnHold(locale: Locale(identifier: "zh-CN"))
                .onRecognizeLatest(update: $voiceText)
                .onChange(of: voiceText) { newValue in
                    // 当检测到语音识别到故事关键词时，播放第一段动画
                    if newValue.contains(self.vm.selectedStory!.keyWord) && self.recognizedKey != true {
                        self.recognizedKey = true
                        self.playFirstAV()
                        self.vm.playSound(self.vm.selectedStory!.actionTintSound)
                    }
                }
                .scaleEffect(0.8)
                .disabled(self.isPlayingVideo)
                .padding(.vertical, 20)
        }
    }
    
    var colorChosenSection: some View {
        ScrollView {
                ForEach(K.AppColor.colors, id: \.self) { color in
                    colorItem(color: color)
                }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 1)
        )
    }

    private func colorItem(color: Color) -> some View {
        Button {
            self.selectedColor = color
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: 80, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.selectedColor == color ? Color.blue : Color.clear, lineWidth: 2)
                )
                .padding(.vertical, 5)
        }
    }

    var figureChosenSection: some View {
        VStack {
            ForEach(vm.selectedChallenge!.figures, id: \.self) { figure in
                FiguresCell(
                    image: figure,
                    selectedFigure: $selectedAnimals,
                    selectedColor: $selectedColor,
                    gestureFlag: $gestureFlag
                )
                .padding(.vertical, 5)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
        .onChange(of: self.gestureFlag) { newValue in
            if self.recognizedKey {
                self.checkFinishGame()
            }
        }
    }
}

// MARK: - Functions
extension StoryView {
    func playFirstAV() {
        self.vm.playVideo()
        // 禁止语音按钮，播放视频提示音
        self.isPlayingVideo = true

        delay(by: 1) {
            self.voiceText = "按住按钮说话"
            self.vm.stopVideo()
            self.isPlayingVideo = false
        }
    }

    func checkFinishGame() {
        if self.selectedAnimals == self.vm.selectedStory!.targetFigure && self.selectedColor == self.vm.selectedStory!.targetColor {
            if self.recognizedKey {
                self.vm.playVideo()
                delay(by: 3) {
                    self.vm.finishedGame()
                    self.path.append("VictoryView")
                }
            }
        } else {
            self.vm.playSound("A-错误提醒")
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = StoryGameVM()
        let story = vm.model.challenges[0].stories[0]
        vm.chooseStory(story: story)
        vm.chooseChallenge(challenge: vm.model.challenges[0])
        
        return StoryView(path: .constant(NavigationPath()), vm: vm)
    }
}
