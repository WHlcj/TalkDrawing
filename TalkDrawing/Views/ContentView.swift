// TO DO
// 1.视图之间传递信息
import SwiftUI

struct ContentView: View {
    @State var view: AppRouter
    // APP导航路由
    @Binding var path: NavigationPath
    
    var body: some View {
        switch view {
        case .HomeView:
            HomeView()
        case .MainView:
            MainView(path: $path)
        // 故事闯关涂鸦
        case .StoryChallengeView:
            StoryChallengeView(path: $path)
//        case .StoryView:
//            StoryView()
//            
        case .DrawBoardView:
            DrawBoardView(path: $path)
        // 社区广场
        case .CommunityView:
            CommunityView()
        // 个人主页
        case .ProfileView:
            ProfileView(path: $path)
        // 设置页面
        case .SettingView:
            SettingView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        ContentView(view: AppRouter.HomeView, path: $path)
    }
}
