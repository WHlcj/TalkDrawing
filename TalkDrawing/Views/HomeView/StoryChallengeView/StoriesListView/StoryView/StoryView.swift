
import SwiftUI
import AVKit

struct StoryView: View {
    // 故事闯关控制VM
    @ObservedObject var vm: StoryGameVM
    // 选中的故事
    let story: Story
    // 颜色选择
    @State private var selectedColor = Color.green
    // 动物选择
    @State private var selectedAnimals = ""
    
    var body: some View {
        ZStack {
            // background
            Background()
            
            // content
            HStack {
                functionButtons
                videoSection
                colorChosenSection
                animalChosenSection
            }
            .padding(30)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            vm.initVideoPlayer()
            vm.chooseStory(story: story)
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
            // 下载的功能按钮
            Button {
                
            } label: {
                Image(K.AppIcon.downloadButton)
            }
        }
    }
    // 视频区域
    var videoSection: some View {
        ZStack {
            // background
            Rectangle()
                .fill(.white)
                .opacity(0.5)
            
            // content
            VStack {
                VideoPlayer(player: vm.player)
                    .onAppear {

                    }
                    .frame(maxHeight: 550)
                    .padding(.horizontal)
                // 隐藏控件
                    .disabled(true)
            }
        }
        .onTapGesture {
            vm.finishedGame()
        }
    }
    // 颜色选择区
    var colorChosenSection: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(K.AppColor.colors, id: \.self) { color in
                    ColorCell(selectedColor: $selectedColor, color: color)
                }
            }
        }
    }
    // 动物选择区
    var animalChosenSection: some View {
        VStack(spacing: 20) {
            ForEach(K.AppIcon.animals, id: \.self) { animal in
                AnimalsCell(animal: animal, selectedAnimal: $selectedAnimals, selectedColor: $selectedColor)
            }
        }
    }
    
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var vm = StoryGameVM()
        let story = Story(title: "门前大桥下", parentTitle: "童话寓言")
        StoryView(vm: vm, story: story)
    }
}
