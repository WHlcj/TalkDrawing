//
//  File.swift
//  TalkDrawing
//
//  Created by 何纪栋 on 2023/7/29.
//

import SwiftUI

///App Tab's
enum Tab: String, CaseIterable {
    case home = "Home"
    case community = "Community"
    case profile = "Profile"
    
    var Image: String {
        switch self {
        case .home: return "home"
        case .community: return "community"
        case .profile: return "profile"

        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}
