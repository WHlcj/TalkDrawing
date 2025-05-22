
import SwiftUI
import AVKit

struct StoryView: View {
    @State private var selectedColor = Color.green
    @State private var selectedAnimals = ""
    @State private var voiceText = "按住按钮说话"     // 语音文本识别与关键词检测
    @State private var gestureFlag = false          // 是否上色并放置动物
    @State private var recognizedKey = false        // 是否识别完关键词
    
    var body: some View {
        ZStack {
            TDThemeBackground()
            
            HStack(spacing: 10) {
                videoSection
                colorChosenSection
                figureChosenSection
            }
            .padding()
        }
        .onAppear {
            if StoryGameVM.shared.selectedStory!.welcomeSound != "" {
                AudioManager.shared.playSound(StoryGameVM.shared.selectedStory!.welcomeSound)
            } else {
                AudioManager.shared.playSound(StoryGameVM.shared.selectedStory!.actionTintSound)
                self.recognizedKey = true
            }
        }
        .onDisappear {
            AudioManager.shared.stopSound()
        }
    }
}

extension StoryView {
    var headerButtons: some View {
        HStack {
            TDThemeBackButton()
            Spacer()
            Text("《\(StoryGameVM.shared.selectedStory!.title)》")
                .font(.system(size: 42).bold())
                .foregroundColor(K.AppColor.ThemeColor)
            TDPromptSpeakingButton(soundName:StoryGameVM.shared.selectedStory!.storySoundUrl)
            Spacer()
        }
        .padding(.vertical)
    }
    
    var videoSection: some View {
        VStack(spacing: 20) {
            headerButtons
            VideoPlayer(player: StoryGameVM.shared.videoPlayer)
                .aspectRatio(144.0/81.0, contentMode: .fit)
                .disabled(true) // 隐藏视频控件
            Text(voiceText)
                .font(.system(size: 20).bold())
            voiceButton
            Spacer()
        }
    }

    var voiceButton: some View {
        TDVoiceRecordButton(
            mode: .holdToRecord,
            recognizedText: $voiceText,
            onRecordingStart: {
                print("开始录音")
            },
            onRecordingStop: {
                print("停止录音")
            }
        )
        .onChange(of: voiceText) { newValue in
            // 当检测到语音识别到故事关键词时，播放第一段动画
            if newValue.contains(StoryGameVM.shared.selectedStory!.keyWord) && self.recognizedKey != true {
                self.recognizedKey = true
                self.playFirstAV()
                AudioManager.shared.playSound(StoryGameVM.shared.selectedStory!.actionTintSound)
            }
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
            ForEach(StoryGameVM.shared.selectedChallenge!.figures, id: \.self) { figure in
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

extension StoryView {
    func playFirstAV() {
        StoryGameVM.shared.playVideo()

        delay(by: 1) {
            self.voiceText = "按住按钮说话"
            StoryGameVM.shared.stopVideo()
        }
    }

    func checkFinishGame() {
        if self.selectedAnimals == StoryGameVM.shared.selectedStory!.targetFigure && self.selectedColor == StoryGameVM.shared.selectedStory!.targetColor {
            if self.recognizedKey {
                StoryGameVM.shared.playVideo()
                delay(by: 3) {
                    StoryGameVM.shared.finishedGame()
                    NavigationManager.shared.navigateTo("VictoryView")
                }
            }
        } else {
            AudioManager.shared.playSound("A-错误提醒")
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        let story = StoryGameVM.shared.model.challenges[0].stories[0]
        StoryGameVM.shared.chooseStory(story: story)
        StoryGameVM.shared.chooseChallenge(StoryGameVM.shared.model.challenges[0])
        
        return StoryView()
    }
}
