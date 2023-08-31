
import SwiftUI

// App通用数据常量
class K {
    class AppColor {
        // 主题按钮色用于返回按钮,设置按钮,一些场景底色背景(区别是透明度不同): 故事闯关模块选择背景、语音日记涂鸦副标题栏背景、故事演说家作品栏背景色
        static let ThemeButtonColor = Color(red: 1.00, green: 0.41, blue: 0.71) //#FF69B4
        // 语音日记副标题栏汉字背景色、故事演说家板块选择背景色
        static let ThemeColor = Color(red: 1.00, green: 0.08, blue: 0.58) //#FF1493
        // HomeView
        static let HomeViewItemBackgroundColor = Color(red: 1.00, green: 0.41, blue: 0.78, opacity: 0.7)
        static let HomeViewItemBackgroundCircleColor = Color(red: 0.91, green: 0.13, blue: 0.53)
        static let HomeViewItemShadow = Color(red: 0.17, green: 0.15, blue: 0.19, opacity: 0.5)
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
            Color.black     
        ]
    }

    class AppIcon {
        // HomeView
        static let HomeItemPencil = "pencil"
        static let HomeItemUnlock = "unlock"
        static let HomeItemMicrophone = "microphone"
        // StoryGameIcon
        static let StoryChallengeIsLocked = "imageLock"
        static let StoryChallengeIsUnLock = "imageUnlock"
        // 精选绘本
        static let SelectedPictureBooks = ["SelectedPictureBookOne" , "SelectedPictureBookTwo", "SelectedPictureBookThree"]
        // 返回按钮
        static let backButton = "backButton"
        // 故事讲述按钮
        static let speaker = "speaker"
        // 星星⭐️
        static let star = "star"
        // 左箭头
        static let leftArrow = "leftArrow"
        // 右箭头
        static let rightArrow = "rightArrow"
        // 完成游戏图标
        static let finishGame = "finishGame"
        // 返回首页图标
        static let backHome = "backHome"
        
        // DialogDrawingGameIcon
        // 画图工具
        static let tools = ["drawingPencil", "inkjetPen", "paintBucket"]
        // 橡皮擦
        static let eraser = "eraser"
        // 保存下载
        static let download = "download"
        // 删除按钮
        static let trashbin = "trashbin"
        // 画笔粗细滑条
        static let slider = "sliderTrack"
        
        // SpeakingGame
        // 关闭弹窗
        static let closeSheet = "closeSheet"
        // 得分表
        static let scoreBoard = "scoreBoard"
    }
}
