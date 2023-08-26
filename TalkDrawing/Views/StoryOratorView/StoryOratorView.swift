
import SwiftUI

struct StoryOratorView: View {
    // App路由导航
    @Binding var path: NavigationPath
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
                    .frame(width: 350, height: 150)
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
    
    var storyCollection: some View {
        VStack {
            Rectangle()
                .fill(K.AppColor.ThemeButtonColor)
                .opacity(0.3)
        }
    }
    
}

struct StoryOratorView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        StoryOratorView(path: $path)
    }
}
