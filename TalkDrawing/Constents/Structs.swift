
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
                .frame(width: 78, height: 54)
                .foregroundColor(K.AppColor.ThemeButtonColor)
        }
    }
}

/// 进入设置按钮
struct SettingButton: View {
    // App导航路由
    @Binding var path: NavigationPath
    var body: some View {
        Button {
            path.append(AppRouter.SettingView)
        } label: {
            Image(K.AppIcon.settingButton)
                .renderingMode(.template)
                .resizable()
                .frame(width: 50, height: 50)//图片默认大小是64x64
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
