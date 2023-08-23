
// TODO
// 1.增加注释信息

import SwiftUI

struct VictoryView: View {
    
    @Environment(\.dismiss) var dismiss
    // App路由导航
    @Binding var path: NavigationPath
    // 星星数量
    var number = 1
    //
    var title = "下一关"
    //
    var active: (() -> Void)?
    
    
    var body: some View {
        ZStack{
            // background
            K.AppColor.ThemeButtonColor
                .opacity(0.3)
                .ignoresSafeArea()
            
            // content
            VStack(spacing: 50) {
                // 完成啦
                Image(K.AppIcon.finishGame)
                
                stars
                
                functionButtons
            }
        }
    }
}

// MARK: - Conponents
extension VictoryView {
    /// 星星数量
    var stars: some View {
        HStack {
            ForEach(1...number, id: \.self) { item in
                Image(K.AppIcon.star)
                    .resizable()
                    .frame(width: 150, height: 150)
            }
        }
        .padding(.bottom, 50)
    }
    /// 功能按钮区
    var functionButtons: some View {
        HStack(spacing: 100) {
            // 返回主页按钮
            VictoryItem(icon: K.AppIcon.backHome, title: "主页") {
                path.removeLast(path.count)
            }
            // 返回上一页按钮
            VictoryItem(icon: K.AppIcon.leftArrow, title: "返回") {
                dismiss()
            }
            // 功能按钮
            VictoryItem(icon: K.AppIcon.rightArrow, title: "下一关")
        }
    }
    
    struct VictoryItem: View {
        let icon: String
        let title: String
        var active: (() -> Void)?
        
        var body: some View {
            Button {
                if let action = active {
                    action()
                }
            } label: {
                VStack {
                    Image(icon)
                    Text(title)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }
        }
    }
}


struct VictoryView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        VictoryView(path: $path, number: 3)
    }
}
