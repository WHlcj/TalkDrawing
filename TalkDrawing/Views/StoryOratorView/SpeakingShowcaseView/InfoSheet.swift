
import SwiftUI

struct InfoSheet: View {
    
    @Binding var showSheets: Bool
    
    var body: some View {
        ZStack {
            K.AppColor.ThemeButtonColor
                .opacity(0.3)
                .ignoresSafeArea()

            if showSheets {
                RoundedRectangle(cornerRadius: 25)
                    .fill(K.AppColor.ThemeButtonColor.opacity(0.8))
                    .frame(width: 350, height: 200)
                    .overlay(
                        VStack {
                            Image(K.AppIcon.closeSheet)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            VStack {
                                Text("请先完成亲子分享乐园")
                                Text("再查看语言能力报告")
                            }
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Button {
                                showSheets = false
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(K.AppColor.ThemeColor)
                                    .frame(width: 80, height: 50)
                                    .overlay(
                                        Text("好的")
                                            .font(.system(size: 25))
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                            .padding()
                    )
            }
        }
    }
}

struct InfoSheet_Previews: PreviewProvider {
    static var previews: some View {
        @State var showSheets = true
        InfoSheet(showSheets: $showSheets)
    }
}
