
import SwiftUI

/// 我的绘本单元
struct DrawingBookCell: View {
    
    // APP导航路由
    @Binding var path: NavigationPath
    // 选择的story
    let story: Story
    // 我是故事演说家的ViewModel
    @ObservedObject var vm: SpeakingGameVM
    
    var body: some View {
        Button {
            // 只是做一个点击有闪烁效果的链接导航
        } label: {
            VStack {
                NavigationLink(destination: SpeakingShowcaseView(path: $path, vm: vm, story: story)) {
                    Image(story.title)
                }
            }
        }
    }
}

struct DrawingBookCell_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var path = NavigationPath()
        @State var story = Story(title: "门前大桥下", parentTitle: "经典儿歌", url: Bundle.main.url(forResource: "门前大桥下", withExtension: "mp4"))
        @StateObject var vm = SpeakingGameVM()
        DrawingBookCell(path: $path, story: story, vm: vm)
    }
}
