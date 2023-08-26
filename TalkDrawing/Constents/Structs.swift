
import SwiftUI

/// 大部分页面背景
struct Background: View {
    var body: some View {
        Image("background")
            .resizable()
            .ignoresSafeArea()
    }
}

/// 自定义的粉色箭头返回按钮
struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(K.AppIcon.backButton)
                .renderingMode(.template)
                .resizable()
                .frame(width: 65, height: 45)
                .foregroundColor(K.AppColor.ThemeButtonColor)
        }
    }
}

/// 自定义导航栏
///
/// - Parameter image: 标题图标
/// - Parameter title: 标题内容
struct NavigationBar: View {
    
    var image: String
    var title: String
    
    var body: some View {
        HStack {
            BackButton()
            Spacer()
            HomeItem(image: image, title: title)
            Spacer()
            SpeakingButton()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.horizontal)
    }
}

///  功能介绍语音按钮
struct SpeakingButton: View {
    var body: some View {
        Button {
            
        } label: {
            Image(K.AppIcon.speaker)
                .renderingMode(.template)
                .resizable()
                .frame(width: 45, height: 45)//图片默认大小是64x64
                .foregroundColor(K.AppColor.ThemeButtonColor)
        }
    }
}

/// 颜色选择区
struct ColorChosenSection: View {
    // 绑定的颜色选择
    @Binding var selectedColor: Color
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(K.AppColor.colors, id: \.self) { color in
                    ColorCell(selectedColor: $selectedColor, color: color)
                }
            }
        }
    }
}

/// 主要功能区下的标题栏
struct HomeItem: View {
    var image: String
    var title: String
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 35)
                .fill(K.AppColor.HomeViewItemBackgroundColor)
                .shadow(color: K.AppColor.HomeViewItemShadow, radius:3, x: 3, y: 6)
                .frame(width: 100, height: 100)
                .overlay {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(K.AppColor.HomeViewItemBackgroundCircleColor)
                        .frame(width: 95, height: 95)
                        .overlay {
                            Image(image)
                                .resizable()
                                .frame(width: image != "pencil" ? 85 : 65, height: image != "pencil" ? 85 : 65)
                        }
                }
                .padding(.trailing, 20)
            Text(title)
                .font(.system(size: 42).bold())
            
        }
    }
}

/// app的消息提醒弹窗
/// - parameter text: This is the title for the alert.
/// - parameter value: This is the binding value which control your alert presend.
struct TextAlert: View {
    
    var text: String
    
    @Binding var boolValue: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image("appicon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .cornerRadius(13)
                Text(text)
                    .foregroundColor(.black)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
            )
        }
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity.animation(.spring())))
        .padding(.bottom, 20)
    }
}
