
import SwiftUI

struct ComicCells: View {
    @StateObject var vm = SpeakingGameVM.shared
    let width: CGFloat
    
    var body: some View {
        ForEach(0..<SpeakingGameVM.shared.comics.count, id: \.self) { index in
            Button {
                SpeakingGameVM.shared.chooseComic(SpeakingGameVM.shared.comics[index])
                NavigationManager.shared.navigateTo("SpeakingShowcaseView")
            } label: {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .aspectRatio(1.5 , contentMode: .fit)
                        .frame(width: width)
                    Image(uiImage: SpeakingGameVM.shared.comics[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width)
                        .overlay(
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        SpeakingGameVM.shared.deleteComics(at: index)
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
