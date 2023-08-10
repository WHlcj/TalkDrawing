
import SwiftUI

// App通用数据常量
class K {
    
    //屏幕尺寸
    class ScreenSize {
        static let screenSize = UIScreen.main.bounds.size
    }
    
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
        // 涂鸦🎨
        static let colors = [
            Color(red: 0.93, green: 0.46, blue: 0.18), // 橙
            Color(red: 0.98, green: 0.87, blue: 0.30), // 黄
            Color(red: 0.65, green: 0.84, blue: 0.31), // 草绿
            Color(red: 0.52, green: 0.82, blue: 0.45), // 冷色绿
            Color(red: 0.36, green: 0.80, blue: 0.64), // 青
            Color(red: 0.42, green: 0.81, blue: 0.86), // 冷色蓝
            Color(red: 0.59, green: 0.86, blue: 0.98), // 浅蓝
            Color(red: 0.30, green: 0.68, blue: 0.98), // 深蓝
            Color(red: 0.46, green: 0.31, blue: 0.98), // 紫
            Color(red: 0.55, green: 0.61, blue: 0.97), // 浅紫
        ]
        
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
        // 动物
        static let animals = ["deer", "pig",  "horse", "frog", "sheep", "duck", "chicken"]
        // 精选绘本
        static let SelectedPictureBooks = ["SelectedPictureBookOne" , "SelectedPictureBookTwo", "SelectedPictureBookThree"]
        // 返回按钮
        static let backButton = "backButton"
        // 设置按钮
        static let settingButton = "settingButton"
        // 下载按钮
        static let downloadButton = "downloadButton"
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
