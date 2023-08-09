
import Foundation

// TabBar常量
enum Tab: CaseIterable {
    case home
    case community
    case profile
    
    var icon: String {
        
        switch self {
        case .home:
            return "主页"
        case .community:
            return "社区广场"
        case .profile:
            return "我的"
        }
    }
}
