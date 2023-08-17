
import SwiftUI

struct ProfileView: View {
    // App导航路由
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            // background
            Background()
            // content
            VStack(spacing: 35) {
                navigationBar
                profileInfo
            }
        }
    }
}

// MARK: - Components
extension ProfileView {
    // 自定义导航栏
    var navigationBar: some View {
        HStack(alignment: .bottom) {
            Spacer()
            SettingButton(path: $path)
        }
        .padding()
        .padding(.horizontal)
    }
    // 个人资料页
    var profileInfo: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 60) {
                sectionOne
                sectionTwo
            }
            .padding(.horizontal, 100)
        }
    }
    
    // 资料区域一
    var sectionOne: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(K.AppColor.profileBackgroundColor)
            .frame(width: 900, height: 550)
            .overlay {
                VStack(alignment: .leading, spacing: 30) {
                    accountInfoSection
                    functionsSection
                }
            }
    }
    // 资料区域一的账号资料区
    var accountInfoSection: some View {
        HStack(spacing: 15) {
            // 用户头像
            Image(K.AppIcon.ProfileAccountAvatar)
            VStack(alignment: .leading, spacing: 24) {
                // 用户名称
                HStack {
                    Image(K.AppIcon.ProfileAccountTitleIcon)
                    Text("宝贝")
                        .font(.system(size: 35))
                }
                // 账户信息
                RoundedRectangle(cornerRadius: 30)
                    .fill(K.AppColor.ThemeButtonColor)
                    .frame(width: 140, height: 60)
                    .overlay(
                        Text("账户信息")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    )
                // 星星数量信息
                RoundedRectangle(cornerRadius: 30)
                    .fill(K.AppColor.ProfileStarBackgroundColor)
                    .blur(radius: 5)
                    .frame(width: 185, height: 70)
                    .overlay(
                        HStack {
                            Image(K.AppIcon.star)
                                .resizable()
                                .frame(width: 56, height: 56)
                            Text("12")
                                .font(.system(size: 35))
                                .foregroundColor(K.AppColor.ProfileNumbersOfStarColor)
                        }
                    )
            }
        }
    }
    // 资料区域一的功能选项区
    var functionsSection: some View {
        HStack(spacing: 90) {
            ForEach(K.AppIcon.ProfileSectionOneMenu, id: \.self) { item in
                VStack {
                    Image(item)
                    Text(item)
                        .font(.system(size: 25))
                }
                
            }
        }
    }
    // 资料区域二
    var sectionTwo: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(K.AppColor.profileBackgroundColor)
            .frame(width: 900, height: 550)
            .overlay {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300, maximum: 400))], spacing: 40) {
                    ForEach(K.AppIcon.ProfileSectionTwoMenu, id: \.self) { item in
                        RoundedRectangle(cornerRadius: 50)
                            .fill(K.AppColor.ProfileSectionTwoItemColor)
                            .opacity(0.4)
                            .frame(width: 320, height: 116)
                            .overlay(
                                Text(item)
                                    .font(.system(size: 25))
                            )
                            
                    }
                }
            }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        ProfileView(path: $path)
    }
}
