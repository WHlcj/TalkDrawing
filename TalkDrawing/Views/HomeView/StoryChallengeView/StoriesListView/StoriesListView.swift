
import SwiftUI

struct StoriesListView: View {
    
    // APP路由
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
}

// Components
extension StoriesListView {
    
    // 设置按钮
    var settingButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                
            } label: {
                Image("settingItem")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
        }
    }
}

struct StoriesView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        StoriesListView(path: $path, storyChallengeModel: StoryChallengeModel.storyChallenges[0])
    }
}
