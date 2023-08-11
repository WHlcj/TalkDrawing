
import SwiftUI

struct StoryChallengeView: View {
    
    // 返回上一个界面
    @Environment(\.dismiss) var dismiss
    // App导航路由
    @Binding var path: NavigationPath
    // 内容选择
    @State var selectedAges = Ages.zeroToThree
    // 故事闯关模块的ViewModel
    @StateObject var vm = StoryGameVM()
        
    var body: some View {
        ZStack {
            // background
            Background()
            VStack {
                navigationBar
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
    // 自定义导航栏
    var navigationBar: some View {
        HStack(spacing: 300) {
            // 自定义的返回按钮
            BackButton()
            HomeItem(image: K.AppIcon.HomeItemUnlock, title: "故事闯关式涂鸦")
            SettingButton(path: $path)
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
    // StoryChallenges列表
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
                ForEach(vm.challenges) { challenge in
                    if challenge.age.contains(selectedAges) {
                        ChallengeCell(path: $path, challenge: challenge, vm: vm)
                        }
                }
            }
        }
        .padding(40)
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
