import SwiftUI

// 页面导航常量
enum AppRouter: String {
    case MainView               // 主页
    case StoryChallengeView     // 故事闯关涂鸦
    case DialogDrawingView      // 语音日记式涂鸦
    case StoryOratorView        // 我说故事演说家
}

class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    @Published var path = NavigationPath()
    
    private init() {} // 确保单例模式
    
    /// 导航到指定页面
    /// - Parameter destination: 目标页面标识
    func navigateTo(_ destination: String) {
        path.append(destination)
    }
    
    /// 导航到指定路由
    /// - Parameter route: 路由枚举
    func navigateTo(_ route: AppRouter) {
        path.append(route)
    }
    
    /// 返回上一页
    func goBack() {
        path.removeLast()
    }
    
    /// 返回到根页面
    func goToRoot() {
        path.removeLast(path.count)
    }
    
    /// 返回到指定页面
    /// - Parameter count: 返回的层级数
    func goBack(count: Int) {
        path.removeLast(count)
    }
}
