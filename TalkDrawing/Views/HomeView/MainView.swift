
import SwiftUI

struct MainView: View {
    @State private var currentSelected = Tab.home
    @Binding var path: NavigationPath
    
    var body: some View {
        
        ZStack {
            // background
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                // 妙语生画logo
                Image("title")
                    .resizable()
                    .frame(width: 647, height: 195)
                    .padding(.leading, 100)
                HStack(spacing: 200) {
                    // 左侧Item
                    leftItems
                    // 右侧推荐栏
                    rightItems
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 100)
        }
    }
}


// Components
extension MainView {
    
    var leftItems: some View {
        VStack(alignment: .leading, spacing: 60) {
            HomeButtonItem(image: K.AppIcon.HomeItemUnlock, title: "故事闯关式涂鸦", destination: AppRouter.StoryChallengeView, path: $path)
            HomeItem(image: K.AppIcon.HomeItemPencil, title: "语音日记式涂鸦")
            HomeItem(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家")
        }
    }
    
    var rightItems: some View {
        VStack {
            Text("精选绘本")
                .font(.system(size: 70).bold())
            Image("preview")
                .resizable()
                .frame(width: 395, height: 350)
        }
    }
    
    struct HomeButtonItem: View {
        var image: String
        var title: String
        var destination: AppRouter
        @Binding var path: NavigationPath
        var body: some View {
            Button {
                path.append(destination)
            } label: {
                HStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(K.AppColor.HomeViewItemBackgroundColor)
                        .shadow(color: K.AppColor.HomeViewItemShadow, radius:4, x: 4, y: 8)
                        .frame(width: 150, height: 150)
                    
                        .overlay {
                            RoundedRectangle(cornerRadius: 70)
                                .fill(K.AppColor.HomeViewItemBackgroundCircleColor)
                                .frame(width: 145, height: 145)
                                .overlay {
                                    Image(image)
                                        .resizable()
                                        .frame(width: image != "pencil" ? 130 : 100, height: image != "pencil" ? 130 : 100)
                                }
                        }
                        .padding(.trailing, 20)
                    Text(title)
                        .font(.system(size: 50).bold())
                        .foregroundColor(.black)
                }
            }
        }
    }
}
// HomeItem
struct HomeItem: View {
    var image: String
    var title: String
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(K.AppColor.HomeViewItemBackgroundColor)
                .shadow(color: K.AppColor.HomeViewItemShadow, radius:4, x: 4, y: 8)
                .frame(width: 150, height: 150)
                .overlay {
                    RoundedRectangle(cornerRadius: 70)
                        .fill(K.AppColor.HomeViewItemBackgroundCircleColor)
                        .frame(width: 145, height: 145)
                        .overlay {
                            Image(image)
                                .resizable()
                                .frame(width: image != "pencil" ? 130 : 100, height: image != "pencil" ? 130 : 100)
                        }
                }
                .padding(.trailing, 20)
            Text(title)
                .font(.system(size: 50).bold())
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        MainView(path: $path)
    }
}
