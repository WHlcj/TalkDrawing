
import SwiftUI

final class TDToast {
    private static let shared = TDToast()
    private static var alertWindow: UIWindow?
    private static var hostingController: UIHostingController<TextAlert>?

    static func show(_ text: String, duration: TimeInterval = 2, completeBlock: @escaping () -> Void = {}) {
        self.shared._show(text, duration: duration, completeBlock: completeBlock)
    }
    
    private func _show(_ text: String, duration: TimeInterval, completeBlock: @escaping () -> Void) {
        DispatchQueue.main.async {
            TDToast.removeAlert()
            guard let windowScene = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .first as? UIWindowScene else {
                print("[TDToast] Error: No active window scene found")
                return
            }
            
            let alertView = TextAlert(text: text) {
                completeBlock()
            }
            
            // 创建承载控制器
            let hostingController = UIHostingController(rootView: alertView)
            hostingController.view.backgroundColor = .clear
            hostingController.view.isUserInteractionEnabled = false
            
            // 创建悬浮窗口
            let alertWindow = UIWindow(windowScene: windowScene)
            alertWindow.windowLevel = .statusBar + 1
            alertWindow.rootViewController = hostingController
            alertWindow.makeKeyAndVisible()
            
            TDToast.alertWindow = alertWindow
            TDToast.hostingController = hostingController
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                TDToast.removeAlert()
            }
        }
    }
    
    static func removeAlert() {
        self.alertWindow = nil
        self.hostingController = nil
    }
}

struct TextAlert: View {
    let text: String
    let completeBlock: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image("appicon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .cornerRadius(13)
                Text(text)
                    .foregroundColor(.black)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
            )
            .padding(.bottom, 20)
        }
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity.animation(.spring())))
        .onDisappear {
            self.completeBlock()
        }
    }
}
