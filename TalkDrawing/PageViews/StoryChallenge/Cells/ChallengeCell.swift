
import SwiftUI

struct ChallengeCell: View {
    let index: Int
    
    var body: some View {
        Button {
            StoryGameVM.shared.chooseChallenge(at: index)
            NavigationManager.shared.navigateTo("StoriesListView")
        } label: {
            VStack {
                ZStack {
                    Image(StoryGameVM.shared.challenges[index].title)
                    Image(StoryGameVM.shared.challenges[index].isLocked ? K.AppIcon.StoryChallengeIsLocked : K.AppIcon.StoryChallengeIsUnLock)
                }
                
                Text(StoryGameVM.shared.challenges[index].title)
                    .font(.system(size: 25).bold())
                    .foregroundColor(.orange)
            }
        }
        .disabled(StoryGameVM.shared.challenges[index].isLocked ? true : false)
    }
}

struct ChallengeCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = StoryChallenge(title: "童话寓言", age: [.zeroToThree])
        ChallengeCell(index: 0)
    }
}
