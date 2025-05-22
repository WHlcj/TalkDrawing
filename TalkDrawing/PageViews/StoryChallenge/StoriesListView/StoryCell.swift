
import SwiftUI

struct StoryCell: View {
    let index: Int
    @ObservedObject private var vm = StoryGameVM.shared

    var body: some View {
        VStack {
            if index % 2 == 1 {
                oddOrder()
            } else {
                evenOrder()
            }
        }
    }
    
    func oddOrder() -> some View {
        HStack(spacing: -40) {
            VStack {
                Text(vm.selectedChallenge!.stories[index].title)
                    .font(.system(size: 40).bold())
                
                Image(K.AppIcon.star) // 原80x80
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundColor(vm.selectedChallenge!.stories[index].isFinished ? .yellow : .gray)
                
                Button {
                    vm.chooseStory(story: vm.selectedChallenge!.stories[index])
                    NavigationManager.shared.navigateTo("StoryView")
                } label: {
                    Image(vm.selectedChallenge!.stories[index].title)
                        .resizable()
                        .frame(width: 330, height: 225)
                }
            }
            .padding(.top, 100)
            .zIndex(1)
            Image("竖")
                .resizable()
                .frame(width: 225, height: 300) // 原300x400
                .scaleEffect(0.8)
        }
        .padding(.trailing, -90)
    }
    
    func evenOrder() -> some View {
        HStack(spacing: -90) {
            VStack {
                Button {
                    vm.chooseStory(story: vm.selectedChallenge!.stories[index])
                    NavigationManager.shared.navigateTo("StoryView")
                } label: {
                    Image(vm.selectedChallenge!.stories[index].title)// 原440x300
                        .resizable()
                        .frame(width: 330, height: 225)
                }
                Text(vm.selectedChallenge!.stories[index].title)
                    .font(.system(size: 35).bold())
                Image("star")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundColor(vm.selectedChallenge!.stories[index].isFinished ? .yellow : .gray)
            }
            .padding(.bottom, 150)
            .zIndex(1)
            Image("横")
                .resizable()
                .frame(width: 300, height: 225)
        }
        .padding(.trailing, -90)
    }
}

struct StoryCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.cyan
            StoryCell(index: 0)
        }
    }
}
