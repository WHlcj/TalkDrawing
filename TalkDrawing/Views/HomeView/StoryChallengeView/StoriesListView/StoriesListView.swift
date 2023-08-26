
import SwiftUI

struct StoriesListView: View {
    // APP导航路由
    @Binding var path: NavigationPath
    // 故事闯关模块的ViewModel
    @ObservedObject var vm: StoryGameVM
    
    let challenge: StoryChallenge
    
    var stories: [Story] {
        challenge.stories
    }
    
    var body: some View {
        ZStack {
            // background
            Background()
            // 内容空白背景
            VStack {
                navigationBar
                storiesList
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            vm.chooseChallenge(challenge: challenge)
        }
    }
}

// Components
extension StoriesListView {
    
    // 自定义导航栏
    var navigationBar: some View {
        HStack(alignment: .bottom) {
            BackButton()
            Text(challenge.title)
                .font(.system(size: 35).bold())
                .foregroundColor(K.AppColor.ThemeButtonColor)
            Spacer()
            SettingButton()
        }
        .padding()
        .padding(.horizontal)
    }
    
    // 故事列表
    var storiesList: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.adaptive(minimum: 500, maximum: 700))]) {
                ForEach(0..<stories.count, id: \.self) { number in
                    StoryCell(path: $path, order: number, story: stories[number], vm: vm)
                }
            }
            .padding(.horizontal, 90)
        }
    }
}

struct StoriesView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        @StateObject var vm = StoryGameVM()
        StoriesListView(path: $path, vm: vm, challenge: vm.challenges[0])
    }
}
