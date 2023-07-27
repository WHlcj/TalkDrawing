
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
                        Image(tabItem.icon)
                            //.renderingMode(.template)
                            .resizable()
                            .frame(width: tabItem == .home ? 105 : 80, height: 80)
                            .opacity(currentSelectedTab == tabItem ? 1 : 0.5)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding([.top, .horizontal])
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(K.AppColor.tabBar)
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
