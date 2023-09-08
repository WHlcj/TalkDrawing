
import SwiftUI

struct TaleCells: View {
    // App路由导航
    @Binding var path: NavigationPath
    // 游戏VM
    @ObservedObject var vm: SpeakingGameVM
    // 资源VM
    @StateObject var storyVM = StoryGameVM()
    // Cell的宽度
    let width: CGFloat
    
    var body: some View {
        ForEach(storyVM.challenges) { challenge in
            ForEach(challenge.stories) { story in
                if !story.storySpeaker.isEmpty {
                    ZStack {
                        NavigationLink(destination: SpeakingShowcaseView(path: $path, vm: vm, story: story)) {
                            Image(story.title)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width)
                        }
                    }
                }
            }
        }
    }
}
