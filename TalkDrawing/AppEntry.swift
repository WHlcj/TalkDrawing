
import SwiftUI

@main
struct TalkDrawingApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
