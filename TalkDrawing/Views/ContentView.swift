
import SwiftUI

struct ContentView: View {
    @State var destination: AppRouter
    @Binding var path: NavigationPath
    
    var body: some View {
        switch destination {
        case .MainView:
            HomeView()
        case .StoryChallengeView:
            StoryChallengeView(path: $path)
        case .DialogDrawingView:
            DialogDrawingView(path: $path)
        case .StoryOratorView:
            StoryOratorView(path: $path)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        ContentView(destination: AppRouter.MainView, path: $path)
    }
}
