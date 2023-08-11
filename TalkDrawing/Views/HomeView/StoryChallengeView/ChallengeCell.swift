
import SwiftUI

struct ChallengeCell: View {
    
    // APP导航路由
    @Binding var path: NavigationPath
    // 选择的challenge
    let challenge: StoryChallenge
    // 故事闯关模块的ViewModel
    @ObservedObject var vm: StoryGameVM
    
    var body: some View {
        Button {
            // 只是做一个点击有闪烁效果的链接导航
        } label: {
            VStack {
                NavigationLink(destination: StoriesListView(path: $path, vm: vm, challenge: challenge)) {
                    ZStack {
                        Image(challenge.title)
                        Image(challenge.isLocked ? K.AppIcon.StoryChallengeIsLocked : K.AppIcon.StoryChallengeIsUnLock)
                    }
                }
                Text(challenge.title)
                    .font(.system(size: 35).bold())
                    .foregroundColor(.orange)
            }
        }
        .disabled(challenge.isLocked ? true : false)
    }
}

struct ChallengeCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        @StateObject var vm = StoryGameVM()
        let model = StoryChallenge(title: "童话寓言", age: [.zeroToThree])
        ChallengeCell(path: $path, challenge: model, vm: vm)
    }
}
