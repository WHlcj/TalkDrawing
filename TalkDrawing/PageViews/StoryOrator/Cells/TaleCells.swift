import SwiftUI

struct TaleCells: View {
    let width: CGFloat
    
    var body: some View {
        ForEach(StoryGameVM.shared.challenges) { challenge in
            ForEach(challenge.stories) { story in
                if !story.soundUrl.isEmpty {
                    Button {
                        SpeakingGameVM.shared.chooseStory(story)
                        NavigationManager.shared.navigateTo("SpeakingShowcaseView")
                    } label: {
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
