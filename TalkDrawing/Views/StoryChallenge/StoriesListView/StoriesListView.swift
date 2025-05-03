
import SwiftUI

struct StoriesListView: View {
    @Binding var path: NavigationPath
    @ObservedObject var vm: StoryGameVM
    
    let challenge: StoryChallenge
    
    var stories: [Story] {
        self.challenge.stories
    }
    
    var body: some View {
        ZStack {
            ThemeBackground()

            VStack {
                navigationBar
                storiesList
            }
        }
        .onAppear {
            self.vm.chooseChallenge(challenge: self.challenge)
        }
    }
}

extension StoriesListView {
    var navigationBar: some View {
        HStack {
            ThemeBackButton()
            Text(self.challenge.title)
                .font(.system(size: 35).bold())
                .foregroundColor(K.AppColor.ThemeColor)
            Spacer()
        }
        .padding()
    }
    
    var storiesList: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.adaptive(minimum: 500, maximum: 700))]) {
                ForEach(0..<self.stories.count, id: \.self) { number in
                    StoryCell(path: $path, order: number, story: self.stories[number], vm: self.vm)
                }
            }
            .padding(.horizontal, 90)
        }
    }
}

struct StoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = StoryGameVM()
        StoriesListView(path: .constant(NavigationPath()), vm: vm, challenge: vm.challenges[0])
    }
}
