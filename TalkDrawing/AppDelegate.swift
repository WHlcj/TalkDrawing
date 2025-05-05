
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        createLocalImagesFolder()
        getAppSandboxPath()
        
        #if DEBUG
        UserDefaults.standard.set(false, forKey: "CA_DEBUG_TRANSACTIONS")        // 禁用部分非必要的 CA 框架诊断日志
        #endif
        return true
    }
    

    private func createLocalImagesFolder() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsDirectory.appendingPathComponent("SavedImages")
        
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating local images folder: \(error)")
        }
    }
    
    func getAppSandboxPath() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("App Sandbox Path: \(documentsDirectory.path)")
        }
    }
}
