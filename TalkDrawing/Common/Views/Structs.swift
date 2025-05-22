
import SwiftUI
import AVFoundation

struct TDThemeBackground: View {
    var body: some View {
        Image("theme_background")
            .resizable()
            .ignoresSafeArea()
    }
}

struct TDThemeCollectionBackGround: View {
    var body: some View {
        Rectangle()
            .fill(K.AppColor.ThemeColor)
            .opacity(0.3)
            .blur(radius: 5)
    }
}

struct TDThemeNotificationBackground: View {
    var body: some View {
        K.AppColor.ThemeColor
            .opacity(0.3)
            .ignoresSafeArea()
    }
}

struct TDThemeBackButton: View {
    var body: some View {
        Button {
            NavigationManager.shared.goBack()
        } label: {
            Image(K.AppIcon.backButton)
                .renderingMode(.template)
                .resizable()
                .frame(width: 65, height: 45)
                .foregroundColor(K.AppColor.ThemeColor)
        }
        .navigationBarBackButtonHidden(true)
    }
}

/// 主题通用导航栏
///
/// - Parameter image: 标题图标
/// - Parameter title: 标题内容和声音播放内容
struct TDThemeNavigationBar: View {
    var image: String
    var title: String

    var body: some View {
        HStack {
            TDThemeBackButton()
            Spacer()
            TDHomeItem(image: image, title: title)
            Spacer()
            TDPromptSpeakingButton(soundName: title)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

///  功能介绍语音按钮
struct TDPromptSpeakingButton: View {
    var soundName = ""
    @State var isPlaying = false
    
    var body: some View {
        Button {
            AudioManager.shared.playSound(soundName)
        } label: {
            Image(K.AppIcon.speaker)
                .renderingMode(.template)
                .resizable()
                .frame(width: 45, height: 45)//图片默认大小是64x64
                .foregroundColor(K.AppColor.ThemeColor)
        }
        .onDisappear {
            AudioManager.shared.stopSound()
        }
    }
}

/// 主要功能区下的标题栏
struct TDHomeItem: View {
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
