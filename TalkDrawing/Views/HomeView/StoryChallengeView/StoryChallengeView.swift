
import SwiftUI

struct StoryChallengeView: View {
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        ZStack {
            // background
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                topSection
                Group {
                    modelSelection
                    mainContents
                }
                .padding(.horizontal, 150)
                Spacer()
            }
            
            .padding()
        }
    }
}

extension StoryChallengeView {
    // 顶部返回按钮和标题部分
    var topSection: some View {
        HStack(spacing: 300) {
            // 返回按钮
            Button {
                dismiss()
            } label: {
                Image("backBar")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            // topItem
            HomeItem(image: K.AppIcon.HomeItemUnlock, title: "故事闯关式涂鸦")
            Button {
                dismiss()
            } label: {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 64, height: 64)
            }
        }
    }
    // 模块选择部分
    var modelSelection: some View {
        HStack(alignment: .bottom, spacing: 20) {
            Text("模块选择")
                .font(.system(size: 50).bold())
            Text("年龄 : ")
                .font(.largeTitle.bold())
            Button("1-3") {
                
            }
            Button("4-6") {
                
            }
            Button("7-8+") {
                
            }
        }
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    // 主要内容部分
    var mainContents: some View {
        ZStack {
            Rectangle()
                .fill(K.AppColor.StoryChallengeViewContentColor)
                .frame(width: 1200, height: 650)
        }
    }
}

struct StoryChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        StoryChallengeView()
    }
}
