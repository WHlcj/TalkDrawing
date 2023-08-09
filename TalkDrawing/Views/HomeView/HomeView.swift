
import SwiftUI

struct HomeView: View {
    @State private var currentSelected = Tab.home
    // APP导航路由
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack {
                    switch currentSelected {
                    case .home:
                        ContentView(view: AppRouter.MainView, path: $path)
                    case .community:
                        ContentView(view: AppRouter.CommunityView, path: $path)
                    case .profile:
                        ContentView(view: AppRouter.ProfileView, path: $path)
                    }
                }
                .padding(.top, -100)
                .ignoresSafeArea()
                .navigationDestination(for: AppRouter.self) { page in
                    ContentView(view: page, path: $path)
                }
                MyTabBar(currentSelectedTab: $currentSelected)
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
