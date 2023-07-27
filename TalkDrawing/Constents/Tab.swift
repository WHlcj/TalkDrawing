
import Foundation

enum Tab: CaseIterable {
    case home
    case community
    case profile
    
    var icon: String {
        
        switch self {
        case .home:
            return "home"
        case .community:
            return "community"
        case .profile:
            return "profile"
        }
    }
}
