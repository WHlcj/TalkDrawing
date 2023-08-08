
import SwiftUI

struct StoryChallengeView: View {
    
    // 返回上一个界面
    @Environment(\.dismiss) var dismiss
    // App路由
    @Binding var path: NavigationPath
    // 内容选择
    @State var selectedAges = Ages.zeroToThree
    
    @State var challenges = StoryChallengeModel.storyChallenges
    
    var body: some View {
        ZStack {
            // background
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                topSection
                // 加Group是为了方便添加共同修饰词
                Group {
                    modelSelection
                    mainContents
                }
                .padding(.horizontal, 150)
                Spacer()
            }
            
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Components
extension StoryChallengeView {
    // 顶部返回按钮和标题部分
    var topSection: some View {
        HStack(spacing: 300) {
            backButton
            HomeItem(image: K.AppIcon.HomeItemUnlock, title: "故事闯关式涂鸦")
            settingButton
        }
    }
    // 模块选择部分
    var modelSelection: some View {
        HStack(alignment: .bottom, spacing: 20) {
            Text("模块选择")
                .font(.system(size: 50).bold())
            Text("年龄 : ")
                .font(.largeTitle.bold())
            AgesButton(ages: $selectedAges, title: "0-3", turnToage: .zeroToThree)
            AgesButton(ages: $selectedAges, title: "4-6", turnToage: .foreToSix)
            AgesButton(ages: $selectedAges, title: "7-8+", turnToage: .SenvenPlus)
        }
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    // 主要内容部分
    var mainContents: some View {
        ZStack {
            // 粉色背景
            Rectangle()
                .fill(K.AppColor.StoryChallengeViewContentColor)
                .frame(width: 1200, height: 650)
                .overlay(content: {
                        challengeModel
                })
        }
    }
    
    var challengeModel: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.adaptive(minimum: 256, maximum: 300))], spacing: 50) {
                ForEach(challenges) { challenge in
                    if challenge.age == selectedAges {
                        ChallengeCell(path: $path, challenge: challenge)
                        }
                }
            }
        }
        .padding(40)
    }
    
    // 返回按钮
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image("backBar")
                .resizable()
                .frame(width: 98, height: 68)
        }
    }
    
    // 设置按钮
    var settingButton: some View {
        Button {
            path.append(AppRouter.SettingView)
        } label: {
            Image("settingItem")
        }
    }
    

    // 模块年龄选择按钮
    struct AgesButton: View {
        
        @Binding var ages: Ages
        let title: String
        let turnToage: Ages
        
        var body: some View {
            Button {
                ages = turnToage
            } label: {
                Text(title)
                    .bold()
                    .foregroundColor(ages == turnToage ? .black : .gray)
            }
        }
    }
}

struct StoryChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        StoryChallengeView(path: $path)
    }
}
