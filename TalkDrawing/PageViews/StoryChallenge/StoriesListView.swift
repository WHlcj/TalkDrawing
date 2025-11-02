
import SwiftUI

struct StoriesListView: View {
    @ObservedObject private var vm = StoryGameVM.shared
    
    var body: some View {
        ZStack {
            TDThemeBackground()

            VStack {
                navigationBar
                storiesList
            }
        }
    }
}

extension StoriesListView {
    var navigationBar: some View {
        HStack {
            TDThemeBackButton()
            if let challenge = vm.selectedChallenge {
                Text(challenge.title)
                    .font(.system(size: 35).bold())
                    .foregroundColor(K.AppColor.ThemeColor)
            } else {
                Text("加载中...")
                    .font(.system(size: 35).bold())
                    .foregroundColor(K.AppColor.ThemeColor)
            }
            Spacer()
        }
        .padding()
    }
    
    var storiesList: some View {
        Group {
            if let challenge = vm.selectedChallenge {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.adaptive(minimum: 500, maximum: 700))]) {
                        ForEach(0..<challenge.stories.count, id: \.self) { index in
                            StoryCell(index: index)
                        }
                    }
                    .padding(.horizontal, 90)
                }
            } else {
                ProgressView()
                    .scaleEffect(2.0)
            }
        }
    }
}

struct StoriesView_Previews: PreviewProvider {
    static var previews: some View {
        StoryGameVM.shared.chooseChallenge(StoryGameVM.shared.challenges[0])
        return StoriesListView()
    }
}
