
import SwiftUI
import AVKit

struct StoryView: View {
    // 媒体播放器
    @State private var player = AVPlayer()
    // 媒体播放控制器
    @State private var playerViewController = AVPlayerViewController()
    // 设定第一次点击后播放到固定时间
    @State private var fixedSeekDuration: Double = 4.0
    @State private var targetTime = 0.0
    
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
        VideoPlayer(player: player)
            .onAppear {
                // 获取资源文件的 URL
                if let videoURL = Bundle.main.url(forResource: "门前大桥下", withExtension: "mp4") {
                    player = AVPlayer(url: videoURL)
                }
                // 隐藏视频自带的控制界面
                playerViewController.player = player
                playerViewController.showsPlaybackControls = false
            }
            .padding(.horizontal)
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
        StoryView()
    }
}
