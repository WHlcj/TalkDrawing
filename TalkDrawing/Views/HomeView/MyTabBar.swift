
import SwiftUI

struct MyTabBar: View {
    @Binding var currentSelectedTab: Tab
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(Tab.allCases, id: \.self) { tabItem in
                    Button {
                        currentSelectedTab = tabItem
                    } label: {
                        HStack {
                            // tabBar的图标
                            Image(tabItem.icon)
                                //.renderingMode(.template)
                                .resizable()
                                // 设置选中时图标大小和颜色
                                .frame(width: currentSelectedTab == tabItem ? (tabItem == .home ? 80 : 60) : (tabItem == .home ? 60 : 45), height: currentSelectedTab == tabItem ? 60 : 45)
                                .opacity(currentSelectedTab == tabItem ? 1 : 0.5)
                            // tabBar的标题
                            Text(tabItem.icon)
                                .font(.system(size: currentSelectedTab == tabItem ? 45 : 35).bold())
                                .foregroundColor(K.AppColor.tabBarTitleColor)
                                .opacity(currentSelectedTab == tabItem ? 1 : 0.5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(K.AppColor.tabBarBackground)
                    .ignoresSafeArea()
                    .opacity(0.8)
            }
        }
    }
}

struct MyTabBar_Previews: PreviewProvider {
    static var previews: some View {
        @State var currentSelectedTab = Tab.home
        
        ZStack {
            // background
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            MyTabBar(currentSelectedTab: $currentSelectedTab)
        }
    }
}
