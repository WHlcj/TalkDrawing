
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
        case .StoryChallengeView:
            StoryChallengeView()
        case .DrawBoardView:
            DrawBoardView(path: $path)
        case .CommunityView:
            CommunityView()
            
        case .ProfileView:
            ProfileView()

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        ContentView(view: AppRouter.HomeView, path: $path)
    }
}
