
import SwiftUI

struct LanguageTrainingBaseView: View {
    
    @Binding var showResult: Bool
    var scores: [Int]
    
    var body: some View {
        ZStack {
            Background()

            VStack {
                customNavigationBar
                Spacer()
                scoreBoard
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Components
extension LanguageTrainingBaseView {
    
    /// 自定义NavigationBar
    var customNavigationBar: some View {
        HStack {
            backbutton
            Spacer()
            RoundedRectangle(cornerRadius: 25)
                .fill(K.AppColor.ThemeButtonColor)
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
    /// 自定义返回按钮
    var backbutton: some View {
        Button {
            showResult = false
        } label: {
            Image(K.AppIcon.backButton)
                .renderingMode(.template)
                .resizable()
                .frame(width: 65, height: 45)
                .foregroundColor(K.AppColor.ThemeButtonColor)
        }
    }
    /// 语言能力得分板
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
        LanguageTrainingBaseView(showResult: $showResult, scores: [9,8,6,8])
    }
}
