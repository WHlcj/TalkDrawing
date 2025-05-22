
import SwiftUI

struct TaleCells: View {
    // 游戏VM
    @ObservedObject var vm: SpeakingGameVM
    // 资源VM
    @StateObject var storyVM = StoryGameVM()
    // Cell的宽度
    let width: CGFloat
    
    var body: some View {
        ForEach(storyVM.challenges) { challenge in
            ForEach(challenge.stories) { story in
                if !story.storySoundUrl.isEmpty {
                    ZStack {
                        NavigationLink(destination: SpeakingShowcaseView(vm: vm, story: story)) {
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
