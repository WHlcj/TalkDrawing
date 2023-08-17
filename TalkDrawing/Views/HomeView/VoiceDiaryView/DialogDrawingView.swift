
import SwiftUI

struct DialogDrawingView: View {
    // App路由导航
    @Binding var path: NavigationPath
    // 选择的颜色
    @State var selectedColor = Color.green
    
    var body: some View {
        ZStack {
            // background
            Background()
            
            // content
            VStack {
                navigationBar
                HStack {
                    DrawBoardView(path: $path, selectedColor: $selectedColor)
                    ColorChosenSection(selectedColor: $selectedColor)
                }
                
            }
            .padding()
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
    }
}


// MARK: - Componenrts
extension DialogDrawingView {
    // 自定义导航栏
    var navigationBar: some View {
        HStack {
            // 自定义的返回按钮
            BackButton()
            Spacer()
            HomeItem(image: K.AppIcon.HomeItemPencil, title: "语音日记式涂鸦")
            Spacer()
            SettingButton(path: $path)
        }
        .frame(maxWidth: .infinity)
    }
}


struct DialogDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        DialogDrawingView(path: $path)
    }
}
