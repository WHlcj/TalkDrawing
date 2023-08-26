
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
        // 语音日记式涂鸦
        case .DialogDrawingView:
            DialogDrawingView(path: $path)
        // 我是故事演说家
        case .StoryOratorView:
            StoryOratorView(path: $path)
            
        case .CommunityView:
            CommunityView()
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
        ContentView(view: AppRouter.MainView, path: $path)
    }
}
