
import SwiftUI

struct HomeView: View {
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ThemeBackground()
                
                VStack {
                    Image("home_title")
                        .resizable()
                        .frame(width: 500, height: 160)
                    HStack {
                        Spacer()
                        mainMenu
                        Spacer()
                        Spacer()
                        pictureBooks
                        Spacer()
                    }
                    .frame(maxHeight: 500)
                }
                .padding()
            }
            .navigationDestination(for: AppRouter.self) { page in
                ContentView(destination: page, path: $path)
            }
        }
    }
}

extension HomeView {
    var mainMenu: some View {
        VStack {
            Spacer()
            HomeFunctionItem(image: K.AppIcon.HomeItemUnlock, title: "故事闯关式涂鸦", destination: AppRouter.StoryChallengeView, path: $path)
            Spacer()
            HomeFunctionItem(image: K.AppIcon.HomeItemPencil, title: "语音日记式涂鸦", destination: AppRouter.DialogDrawingView, path: $path)
            Spacer()
            HomeFunctionItem(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家", destination: AppRouter.StoryOratorView, path: $path)
            Spacer()
        }
    }

    var pictureBooks: some View {
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
    
    struct HomeFunctionItem: View {
        var image: String
        var title: String
        var destination: AppRouter
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
