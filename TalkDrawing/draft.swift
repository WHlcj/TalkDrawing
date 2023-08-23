
import SwiftUI
import SwiftSpeech

struct draft: View {
    
    @StateObject var vm = DrawingGameVM()
    // 语音文本
    @State var voiceText = "按住按钮说话"

    var body: some View {
        VStack {
            SwiftSpeech.RecordButton()
                .swiftSpeechRecordOnHold(locale: Locale(identifier: "zh-CN"))
                .onRecognizeLatest(update: $voiceText)
                .gesture(
                    LongPressGesture(minimumDuration: 0.5, maximumDistance: 10)
                        .onEnded { _ in
                            vm.fetchImage(text: voiceText)
                        }
                )

                .onAppear {
                    SwiftSpeech.requestSpeechRecognitionAuthorization()
                }
            AsyncImage(url: URL(string: vm.model.img)) { image in
                image
                    .resizable()
                    .frame(width: 100)
                    .aspectRatio(1, contentMode: .fit)
            } placeholder: {
                Color.gray.opacity(0.3)
                    .overlay(Text(voiceText))
                    .frame(width: 200, height: 200)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
        
    }
}

struct draft_Previews: PreviewProvider {
    static var previews: some View {
        draft()
    }
}
