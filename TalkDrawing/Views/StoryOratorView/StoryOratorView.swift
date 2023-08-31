
import SwiftUI

// 当前本文件

struct StoryOratorView: View {
    // App路由导航
    @Binding var path: NavigationPath
    // 游戏VM
    @StateObject var vm = SpeakingGameVM()
    @StateObject var storyVM = StoryGameVM()
    // 模块选择
    @State var selectedModel = "我的绘本"
    
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                NavigationBar(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家")
                HStack {
                    sideBar
                    Rectangle()
                        .frame(width: 15)
                        .foregroundColor(.white)
                    storyCollection
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            vm.loaComics()
        }
    }
}

// MARK: - Components

extension StoryOratorView {
    /// 侧栏
    var sideBar: some View {
        VStack(alignment: .leading, spacing: 50) {
            Spacer()
            ForEach (["我的绘本", "宝宝作品"], id: \.self) { item in
                Rectangle()
                    .frame(width: 250, height: 130)
                    .foregroundColor(K.AppColor.ThemeColor)
                    .opacity(selectedModel == item ? 0.7 : 0.3)
                    .overlay(
                        Text(item)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        selectedModel = item
                    }
            }
            Spacer()
            Spacer()
        }
    }
    /// 故事集
    var storyCollection: some View {
        ZStack {
            // 粉色背景图
            Rectangle()
                .fill(K.AppColor.ThemeButtonColor)
                .opacity(0.3)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 240, maximum: 250), spacing: 10)]) {
                    if selectedModel == "宝宝作品" {
                        ForEach(0..<vm.comics.count, id: \.self) { index in
                            // 连环画
                            ComicCell(path: $path, vm: vm, index: index)
                        }
                    }
                    else if selectedModel == "我的绘本" {
                        ForEach(storyVM.challenges) { challenge in
                            ForEach(challenge.stories) { story in
                                    // 故事集
                                if !story.storySpeaker.isEmpty {
                                    DrawingBookCell(path: $path, story: story, vm: vm)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    
    
}

struct StoryOratorView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        StoryOratorView(path: $path)
    }
}
