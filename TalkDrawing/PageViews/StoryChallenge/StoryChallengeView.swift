import SwiftUI
import AVKit

struct StoryChallengeView: View {
    @State var selectedAges = Ages.zeroToThree
    
    var body: some View {
        ZStack {
            TDThemeBackground()
            
            VStack(spacing: 0) {
                TDThemeNavigationBar(image: K.AppIcon.HomeItemUnlock, title: "故事闯关式涂鸦")
                agesModelSelection
                challengeCollection
            }
        }
        .navigationDestination(for: String.self) { destination in
            if destination == "StoriesListView" {
                StoriesListView()
            }
            else if destination == "StoryView" {
                StoryView()
            }
            else if destination == "VictoryView" {
                VictoryView(soundName: "A-完成", starNumber: 1, title: "故事闯关成功")
            }
        }
    }
}

extension StoryChallengeView {
    var agesModelSelection: some View {
        HStack(alignment: .bottom, spacing: 20) {
            Text("年龄选择 : ")
                .font(.system(size: 25).bold())
            AgeModelButton(curAge: $selectedAges, title: "0~3 岁", targetAge: .zeroToThree)
            AgeModelButton(curAge: $selectedAges, title: "4~6 岁", targetAge: .foreToSix)
            AgeModelButton(curAge: $selectedAges, title: "6+ 岁", targetAge: .SixPlus)
        }
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    var challengeCollection: some View {
        ZStack {
            TDThemeCollectionBackGround()

            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.adaptive(minimum: 200, maximum: 250))], spacing: 30) {
                    ForEach(0..<StoryGameVM.shared.challenges.count, id: \.self) { index in
                        if StoryGameVM.shared.challenges[index].age.contains(selectedAges) {
                            ChallengeCell(index: index)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }

    struct AgeModelButton: View {
        @Binding var curAge: Ages
        let title: String
        let targetAge: Ages
        
        var body: some View {
            Button {
                curAge = targetAge
            } label: {
                Text(title)
                    .bold()
                    .foregroundColor(curAge == targetAge ? .black : .gray)
            }
        }
    }
}

struct StoryChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        StoryChallengeView()
    }
}
