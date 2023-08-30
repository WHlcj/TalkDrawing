
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        //第一次打开app时会有的创建本地图片文件夹的过程
        createLocalImagesFolder()
        //获取app的沙盒地址，用于调试查看画板是否被保存到应用程序内
        getAppSandboxPath()
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
