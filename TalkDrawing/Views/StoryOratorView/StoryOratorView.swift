
import SwiftUI

struct StoryOratorView: View {
    // App路由导航
    @Binding var path: NavigationPath
    // 游戏VM
    @StateObject var vm = SpeakingGameVM()
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
            
            GeometryReader { geomtry in
                let width = geomtry.size.width / 3.4
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: width), spacing: 0)]) {
                        if selectedModel == "宝宝作品" {
                            // 连环画
                            ComicCells(path: $path, vm: vm, width: width)
                        }
                        else if selectedModel == "我的绘本" {
                            // 故事集
                            TaleCells(path: $path, vm: vm, width: width)
                        }
                    }
                    .padding()
                }
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
