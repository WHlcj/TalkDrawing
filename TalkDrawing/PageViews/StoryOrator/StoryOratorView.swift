import SwiftUI

struct StoryOratorView: View {
    @StateObject var vm = SpeakingGameVM.shared
    @State var selectedModel = "故事绘本"
    @State var selectIndex = -1

    var body: some View {
        ZStack {
            TDThemeBackground()
            
            VStack {
                TDThemeNavigationBar(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家")
                HStack {
                    modelSelectionTabs
                    Rectangle()
                        .frame(width: 15)
                        .foregroundColor(.white)
                    storyCollection
                }
            }
        }
        .navigationDestination(for: String.self) { destination in
            if destination == "SpeakingShowcaseView" {
                SpeakingShowcaseView()
            }
        }
        .onAppear {
            vm.loaComics()
        }
    }
}

extension StoryOratorView {
    var modelSelectionTabs: some View {
        VStack(alignment: .leading, spacing: 50) {
            Spacer()
            ForEach (["故事绘本", "我的作品"], id: \.self) { item in
                Rectangle()
                    .frame(width: 250, height: 130)
                    .foregroundColor(K.AppColor.ThemeButtonColor)
                    .opacity(selectedModel == item ? 0.7 : 0.3)
                    .overlay(
                        Text(item)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        selectedModel = item
                    }
            }
            Spacer()
            Spacer()
        }
    }

    var storyCollection: some View {
        ZStack {
            TDThemeCollectionBackGround()
            
            GeometryReader { geomtry in
                let width = geomtry.size.width / 3.4
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: width), spacing: 0)]) {
                        if selectedModel == "我的作品" {
                            ComicCells(width: width)
                        }
                        else if selectedModel == "故事绘本" {
                            TaleCells(width: width)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct StoryOratorView_Previews: PreviewProvider {
    static var previews: some View {
        StoryOratorView()
    }
}
