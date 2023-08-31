
import SwiftUI

/// 宝宝作品单元
struct ComicCell: View {
    // App路由导航
    @Binding var path: NavigationPath
    // 绑定的vm
    @ObservedObject var vm: SpeakingGameVM
    let index: Int
    
    var body: some View {
        ZStack {
            NavigationLink(destination: SpeakingShowcaseView(path: $path, vm: vm, image: Image(uiImage: vm.comics[index]))) {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 240, height: 160)
                    Image(uiImage: vm.comics[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 240, height: 160)
                        .overlay(
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
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

//struct SpeakingCell_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var path = NavigationPath()
//        @StateObject var vm = SpeakingGameVM()
//        ComicCell(path: $path, vm: vm, index: 0)
//    }
//}
