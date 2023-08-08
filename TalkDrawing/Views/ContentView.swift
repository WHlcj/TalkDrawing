// TO DO
// StoriesListView
import SwiftUI

struct ContentView: View {
    @State var view: AppRouter
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
        case .StoriesListView:
            StoriesListView(path: $path, storyChallengeModel: StoryChallengeModel.storyChallenges[0])
        case .StoryView:
            StoryView()
        
            
        case .DrawBoardView:
            DrawBoardView(path: $path)
        // 社区广场
        case .CommunityView:
            CommunityView()
        // 个人主页
        case .ProfileView:
            ProfileView()
        
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
