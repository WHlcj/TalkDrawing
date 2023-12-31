
import SwiftUI

struct HomeView: View {
    // APP导航路由
    @State var path = NavigationPath()

    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Background()
                
                VStack {
                    // 妙语生画logo
                    Image("title")
                        .resizable()
                        .frame(width: 500, height: 160)
                    HStack {
                        Spacer()
                        // 左侧Item
                        leftItems
                        Spacer()
                        Spacer()
                        // 右侧推荐栏
                        SelectedPictureBooks
                        Spacer()
                    }
                    .frame(maxHeight: 500)
                }
                .padding()
            }
            .navigationDestination(for: AppRouter.self) { page in
                ContentView(view: page, path: $path)
            }
        }
    }
}


// Components
extension HomeView {
    
    var leftItems: some View {
        VStack {
            Spacer()
            HomeButtonItem(image: K.AppIcon.HomeItemUnlock, title: "故事闯关式涂鸦", destination: AppRouter.StoryChallengeView, path: $path)
            Spacer()
            HomeButtonItem(image: K.AppIcon.HomeItemPencil, title: "语音日记式涂鸦", destination: AppRouter.DialogDrawingView, path: $path)
            Spacer()
            HomeButtonItem(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家", destination: AppRouter.StoryOratorView, path: $path)
            Spacer()
        }
    }
    /// 精选绘本栏
    var SelectedPictureBooks: some View {
        VStack {
            Text("精选绘本")
                .font(.system(size: 35).bold())
            ScrollView {
                ForEach(K.AppIcon.SelectedPictureBooks, id: \.self) { book in
                    Image(book)
                        .resizable()
                        .frame(width: 300, height: 250)
                }
            }
        }
    }
    
    struct HomeButtonItem: View {
        var image: String
        var title: String
        var destination: AppRouter
        // App导航路由
        @Binding var path: NavigationPath
        var body: some View {
            Button {
                path.append(destination)
            } label: {
                HStack {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(K.AppColor.HomeViewItemBackgroundColor)
                        .shadow(color: K.AppColor.HomeViewItemShadow, radius:3, x: 3, y: 6)
                        .frame(width: 100, height: 100)
                        .overlay {
                            RoundedRectangle(cornerRadius: 50)
                                .fill(K.AppColor.HomeViewItemBackgroundCircleColor)
                                .frame(width: 95, height: 95)
                                .overlay {
                                    Image(image)
                                        .resizable()
                                        .frame(width: image != "pencil" ? 85 : 65, height: image != "pencil" ? 85 : 65)
                                }
                        }
                        .padding(.trailing, 20)
                    Text(title)
                        .font(.system(size: 42).bold())
                        .foregroundColor(.black)
                }
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
