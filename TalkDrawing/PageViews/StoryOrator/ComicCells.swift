
import SwiftUI

/// 宝宝作品单元
struct ComicCells: View {
    @ObservedObject var vm: SpeakingGameVM
    // Cell的宽度
    let width: CGFloat
    
    var body: some View {
        ForEach(0..<vm.comics.count, id: \.self) { index in
            ZStack { // STA: ZStack
                NavigationLink(destination: SpeakingShowcaseView(vm: vm, image: Image(uiImage: vm.comics[index]))) {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .aspectRatio(1.5 , contentMode: .fit)
                            .frame(width: width)
                        Image(uiImage: vm.comics[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width)
                            .overlay(
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            // 删除连环画
                                            vm.deleteComics(at: index)
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                                .padding(8)
                                        }
                                        .padding()
                                    }
                                    Spacer()
                                }
                            )
                    }
                }
            }
        }
    }
}
