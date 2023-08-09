
import SwiftUI

struct ChallengeCell: View {
    
    // APP导航路由
    @Binding var path: NavigationPath
    let challenge: StoryChallengeModel
    
    var body: some View {
        Button {
            // 这里按钮无作用，只是把下面的NAvigationStack修饰成按钮的形式----点击后有点击效果。
        } label: {
            VStack {
                NavigationLink(destination: StoriesListView(path: $path, storyChallengeModel: challenge)) {
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
        let model = StoryChallengeModel(title: "童话寓言", age: .zeroToThree)
        ChallengeCell(path: $path, challenge: model)
    }
}
