
import SwiftUI
import AVKit


// 当前本文件

struct SpeakingShowcaseView: View {
    
    // App路由导航
    @Binding var path: NavigationPath
    // SpeakingGameVM
    @ObservedObject var vm: SpeakingGameVM
    // 是否为我的绘本
    @State var isStory: Bool
    @State var story: Story?
    @State var image: Image?
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                NavigationBar(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家")
                    .padding(.bottom, 40)
                HStack {
                    mediaSection
                    functionButtons
                }
            }
        }
        .onAppear {
            if let story {
                vm.initVideoPlayer(story: story)
            }
        }
    }
}
// MARK: - Components
extension SpeakingShowcaseView {
    /// 视频播放区
    var mediaSection: some View {
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
    }
    /// 功能按键区
    var functionButtons: some View {
        VStack(spacing: 50) {
            CustomButton(title: "故事情节回顾")
            CustomButton(title: "亲子分享乐园")
            CustomButton(title: "语言能力分析")
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
                        .fill(K.AppColor.ThemeButtonColor)
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


struct SpeakingShowcaseView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        @State var vm = SpeakingGameVM()
        @State var story = Story(title: "门前大桥下", parentTitle: "经典儿歌", url: Bundle.main.url(forResource: "门前大桥下", withExtension: "mp4"), keyWord: "桥", targetAnimal: "duck", targetColor: Color(red: 0.98, green: 0.87, blue: 0.30), welcomeSound: "A-河流上有什么", actionTintSound: "A-拖拽", storySpeaker: "A-数鸭子")
        SpeakingShowcaseView(path: $path, vm: vm, isStory: false, story: story)
    }
}
