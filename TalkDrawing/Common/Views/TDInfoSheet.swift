import SwiftUI

struct TDInfoSheet: View {
    @Binding var isPresented: Bool
    var title: String
    var message: String
    var buttonText: String = "好的"
    var onButtonTap: (() -> Void)?
    
    var body: some View {
        ZStack {
            TDThemeNotificationBackground()
                .opacity(isPresented ? 1 : 0)
                .animation(.easeInOut, value: isPresented)
            
            if isPresented {
                RoundedRectangle(cornerRadius: 25)
                    .fill(K.AppColor.ThemeColor)
                    .frame(width: 200, height: 123)
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                Image(K.AppIcon.closeSheet)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        isPresented = false
                                    }
                                    .padding(.trailing, 5)
                            }
                            .overlay {
                                Text(title)
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }

                            Text(message)
                                .multilineTextAlignment(.center)
                                .font(.body)
                                .foregroundColor(.white)
                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                            Button {
                                if let action = onButtonTap {
                                    action()
                                }
                                isPresented = false
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(K.AppColor.ThemeButtonColor)
                                    .frame(width: 50, height: 25)
                                    .overlay(
                                        Text(buttonText)
                                            .font(.body)
                                            .foregroundColor(.white)
                                    )

                            }
                        }
                    )
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

struct InfoSheet_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented = true
        TDInfoSheet(
            isPresented: $isPresented,
            title: "提示",
            message: "请先完成亲子分享乐园再查看语言能力报告",
            buttonText: "好的",
            onButtonTap: {
                print("按钮被点击")
            }
        )
    }
}
