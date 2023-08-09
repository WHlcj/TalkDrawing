
import SwiftUI

// App通用数据常量
class K {
    class AppColor {
        // 主题按钮色用于返回按钮,设置按钮等
        static let ThemeButtonColor = Color(red: 0.90, green: 0.40, blue: 0.70)
        // HomeView
        static let HomeViewItemBackgroundColor = Color(red: 1.00, green: 0.41, blue: 0.78, opacity: 0.7)
        static let HomeViewItemBackgroundCircleColor = Color(red: 0.91, green: 0.13, blue: 0.53)
        static let HomeViewItemShadow = Color(red: 0.17, green: 0.15, blue: 0.19, opacity: 0.5)
        // TabBar
        static let tabBarBackground = Color(red: 1, green: 1, blue: 1, opacity: 0.5)
        static let tabBarTitleColor = Color(red: 1.00, green: 0.30, blue: 0.80)
        // StoryChallengeView
        static let StoryChallengeViewContentColor = Color(red: 0.98, green: 0.72, blue: 0.92, opacity: 0.3)
        
        // ProfileView
        // 区域背景颜色
        static let profileBackgroundColor = Color(red: 0.98, green: 0.72, blue: 0.92, opacity: 0.5)
        // 星星数背景颜色
        static let ProfileStarBackgroundColor = Color(red: 0.97, green: 0.62, blue: 0.83)
        // 星星数字体颜色
        static let ProfileNumbersOfStarColor = Color(red: 0.96, green: 0.92, blue: 0.16)
        // 菜单二单元背景色
        static let ProfileSectionTwoItemColor = Color(red: 0.96, green: 0.42, blue: 0.77)
    }

    class AppIcon {
        // HomeView
        static let HomeItemPencil = "pencil"
        static let HomeItemUnlock = "unlock"
        static let HomeItemMicrophone = "microphone"
        // StoryChallengeView
        static let StoryChallengeIsLocked = "imageLock"
        static let StoryChallengeIsUnLock = "imageUnlock"
        // 精选绘本
        static let SelectedPictureBooks = ["SelectedPictureBookOne" , "SelectedPictureBookTwo", "SelectedPictureBookThree"]
        // 返回按钮
        static let backButton = "backButton"
        // 设置按钮
        static let settingButton = "settingButton"
        // 星星⭐️
        static let star = "star"
        
        // ProfileView
        // 用户头像
        static let ProfileAccountAvatar = "avatar"
        // 用户名称处的装饰头像
        static let ProfileAccountTitleIcon = "titleIcon"
        static let ProfileSectionOneMenu = ["星星商店", "语言分析报告", "我的绘本"]
        static let ProfileSectionTwoMenu = ["绘本解锁", "关于我们", "常见问题", "法律条款和隐私中心", "意见反馈", "退出登录"]
    }
    
}
