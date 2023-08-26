
import SwiftUI

struct SpeakingShowcaseView: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                NavigationBar(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家")
            }
        }
    }
}

struct SpeakingShowcaseView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        SpeakingShowcaseView(path: $path)
    }
}
