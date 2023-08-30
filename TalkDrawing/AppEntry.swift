
import SwiftUI

// 当前TalkDrawing

@main
struct TalkDrawingApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        
        WindowGroup {
            HomeView()
            //draft()
        }
    }
}
