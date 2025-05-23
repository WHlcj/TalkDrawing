
import SwiftUI

struct LanguageTrainingBaseView: View {
    var scores: [Int]
    
    var body: some View {
        ZStack {
            TDThemeBackground()

            VStack {
                customNavigationBar
                Spacer()
                scoreBoard
                Spacer()
            }
        }
    }
}

extension LanguageTrainingBaseView {
    var customNavigationBar: some View {
        HStack {
            TDThemeBackButton()
            Spacer()
            RoundedRectangle(cornerRadius: 25)
                .fill(K.AppColor.ThemeColor)
                .opacity(0.7)
                .frame(width: 300, height: 100)
                .overlay(
                    Text("语言训练基地")
                        .font(.system(size: 35))
                )
            Spacer()
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 65, height: 45)
                .foregroundColor(.clear)
        }
        .padding()
        .padding(.horizontal)
    }

    var scoreBoard: some View {// 语言清晰度、语言逻辑性、言语情商能力、语汇能力
        HStack {
            Text("言语情商能力\(scores[2])分")
            VStack {
                Text("语言清晰度\(scores[0])分")
                ScoreBoard(scores: scores)
                Text("语言逻辑性\(scores[1])分")
            }
            Text("语汇能力\(scores[3])分")
        }
        .font(.system(size: 25))
    }
}


struct LanguageTrainingBaseView_Previews: PreviewProvider {
    static var previews: some View {
        @State var showResult = false
        LanguageTrainingBaseView(scores: [9,6,6,8])
    }
}
