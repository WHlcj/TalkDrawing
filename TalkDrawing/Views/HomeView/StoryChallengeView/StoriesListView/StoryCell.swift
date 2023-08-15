
import SwiftUI

struct StoryCell: View {
    // App导航路由
    @Binding var path: NavigationPath
    // 两种排列顺序确定
    let order: Int
    // 故事内容
    let story: Story
    @ObservedObject var vm: StoryGameVM
    
    var body: some View {
        VStack {
            if order % 2 == 1 {
                oddOrder()
            } else {
                evenOrder()
            }
        }
    }
    
    func oddOrder() -> some View {
        HStack(spacing: -40) {
            VStack {
                Text(story.title)
                    .font(.system(size: 40).bold())
                
                Image(K.AppIcon.star)
                    .renderingMode(.template)
                    .foregroundColor(story.isFinished ? .yellow : .gray)
                
                Button {
                    // 只是做一个点击有闪烁效果的链接导航
                } label: {
                    NavigationLink(destination: StoryView(path: $path, vm: vm, story: story)) {
                        Image(story.title)
                    }
                }
            }
            .padding(.top, 150)
            .zIndex(1)
            Image("竖")
                .zIndex(0)
        }
        .padding(.trailing, -90)
    }
    
    func evenOrder() -> some View {
        HStack(spacing: -90) {
            
            VStack {
                Button {
                    // 只是做一个点击有闪烁效果的链接导航
                } label: {
                    NavigationLink(destination: StoryView(path: $path, vm: vm, story: story)) {
                        Image(story.title)
                    }
                }
                Text(story.title)
                    .font(.system(size: 40).bold())
                Image("star")
                    .renderingMode(.template)
                    .foregroundColor(story.isFinished ? .yellow : .gray)
            }
            .padding(.bottom, 150)
            .zIndex(1)
            Image("横")
                .zIndex(0)
        }
        .padding(.trailing, -90)
    }
    
}


struct StoryCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        @StateObject var vm = StoryGameVM()
        let story = Story(title: "门前大桥下", parentTitle: "经典儿歌")
        ZStack {
            // background
            Color.cyan
            
            StoryCell(path: $path, order: 1, story: story, vm: vm)
        }
    }
}
