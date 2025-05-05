
import SwiftUI
import AVKit

struct StoryChallengeView: View {
    @Binding var path: NavigationPath
    @State var selectedAges = Ages.zeroToThree
    @State var vm = StoryGameVM()
    
    var body: some View {
        ZStack {
            ThemeBackground()

            VStack {
                ThemeNavigationBar(image: K.AppIcon.HomeItemUnlock, title: "故事闯关式涂鸦")
                agesModelSelection
                challengeCollection
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
            ThemeCollectionBackGround()

            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.adaptive(minimum: 200, maximum: 250))], spacing: 30) {
                    ForEach(self.vm.challenges) { challenge in
                        if challenge.age.contains(selectedAges) {
                            ChallengeCell(path: $path, challenge: challenge, vm: self.vm)
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
        @State var path = NavigationPath()
        StoryChallengeView(path: $path)
    }
}
