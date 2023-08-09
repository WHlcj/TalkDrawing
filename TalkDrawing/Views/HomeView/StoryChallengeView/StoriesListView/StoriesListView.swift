
import SwiftUI

struct StoriesListView: View {
    // APP导航路由
    @Binding var path: NavigationPath
    
    let storyChallengeModel: StoryChallengeModel
    
    var stories: [Story] {
        storyChallengeModel.stories
    }
    
    var body: some View {
        ZStack {
            // background
            Image("background")
                .resizable()
                .ignoresSafeArea()
            // 内容空白背景
            VStack {
                navigationBar
                storiesList
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Components
extension StoriesListView {
    
    // 自定义导航栏
    var navigationBar: some View {
        HStack(alignment: .bottom) {
            BackButton()
            Text(storyChallengeModel.title)
                .font(.system(size: 50).bold())
                .foregroundColor(K.AppColor.ThemeButtonColor)
            Spacer()
            SettingButton(path: $path)
        }
        .padding()
        .padding(.horizontal)
    }
    
    // 故事列表
    var storiesList: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.adaptive(minimum: 500, maximum: 700))]) {
                ForEach(0..<stories.count, id: \.self) { number in
                    StoryCell(path: $path, order: number, story: stories[number])

                }
            }
            .padding(.horizontal, 90)
        }
    }
}

struct StoriesView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        StoriesListView(path: $path, storyChallengeModel: StoryChallengeModel.storyChallenges[0])
    }
}
