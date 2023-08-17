

import SwiftUI

struct VictoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack{
            // background
            K.AppColor.ThemeButtonColor
                .opacity(0.3)
                .ignoresSafeArea()
            
            // content
            VStack {
                Image(K.AppIcon.finishGame)
                Image(K.AppIcon.star)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 120)
                
                HStack(spacing: 100) {
                    backHomeButton
                    backToStoryListButton
                    nextStoryButton
                }
            }
        }
    }
}

// MARK: - Conponents
extension VictoryView {
    
    // 返回主页按钮
    var backHomeButton: some View {
        Button {
            path.removeLast(path.count)
        } label: {
            VStack {
                Image(K.AppIcon.backHome)
                Text("主页")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        }
    }
    // 返回上一页按钮
    var backToStoryListButton: some View {
        Button {
            dismiss()
        } label: {
            VStack {
                Image(K.AppIcon.leftArrow)
                Text("返回")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        }
    }
    // 下一关按钮
    var nextStoryButton: some View {
        Button {
            dismiss()
        } label: {
            VStack {
                Image(K.AppIcon.rightArrow)
                Text("下一关")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        }
    }
    
    
    
    struct VictoryItem: View {
        let icon: String
        let title: String
        
        var body: some View {
            Button {
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
        VictoryView(path: $path)
    }
}
