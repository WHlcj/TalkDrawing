
import SwiftUI

// 当前本文件

struct StoryOratorView: View {
    // App路由导航
    @Binding var path: NavigationPath
    // 游戏VM
    @StateObject var vm = SpeakingGameVM()
    @StateObject var storyVM = StoryGameVM()
    // 模块选择
    @State var selectedModel = "我的绘本"
    
    // 晚上21:55修改
    @State private var savedImages: [UIImage] = []
    //
    
    var body: some View {
        ZStack {
            Background()
            
            VStack {
                NavigationBar(image: K.AppIcon.HomeItemMicrophone, title: "我是故事演说家")
                HStack {
                    sideBar
                    Rectangle()
                        .frame(width: 15)
                        .foregroundColor(.white)
                    storyCollection
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            vm.loaComics()
            createImageView()
        }
    }
}

// MARK: - Components

extension StoryOratorView {
    /// 侧栏
    var sideBar: some View {
        VStack(alignment: .leading, spacing: 50) {
            Spacer()
            ForEach (["我的绘本", "宝宝作品"], id: \.self) { item in
                Rectangle()
                    .frame(width: 250, height: 130)
                    .foregroundColor(K.AppColor.ThemeColor)
                    .opacity(selectedModel == item ? 0.7 : 0.3)
                    .overlay(
                        Text(item)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        selectedModel = item
                    }
            }
            Spacer()
            Spacer()
        }
    }
    /// 故事集
    var storyCollection: some View {
        ZStack {
            // 粉色背景图
            Rectangle()
                .fill(K.AppColor.ThemeButtonColor)
                .opacity(0.3)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 240, maximum: 250), spacing: 10)]) {
                    if selectedModel == "宝宝作品" {
                        ForEach(0..<savedImages.count, id: \.self) { index in
//                            // 连环画
//                            ComicCell(path: $path, vm: vm, index: index)
                            ZStack {
                                NavigationLink(destination: SpeakingShowcaseView(path: $path, vm: vm, image: Image(uiImage: savedImages[index]))) {
                                    ZStack {
                                        Rectangle()
                                            .fill(.white)
                                            .frame(width: 240, height: 160)
                                        Image(uiImage: savedImages[index])
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 240, height: 160)
                                            .overlay(
                                                VStack {
                                                    HStack {
                                                        Spacer()
                                                        Button {
                                                            deleteImage(at: index)
                                                        } label: {
                                                            Image(systemName: "trash")
                                                                .foregroundColor(.red)
                                                                .padding(8)
                                                        }
                                                        .padding()
                                                    }
                                                    Spacer()
                                                }
                                            )
                                    }
                                }
                            }
                        }
                    }
                    else if selectedModel == "我的绘本" {
                        ForEach(storyVM.challenges) { challenge in
                            ForEach(challenge.stories) { story in
                                    // 故事集
                                if !story.storySpeaker.isEmpty {
                                    DrawingBookCell(path: $path, story: story, vm: vm)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
}

// MARK: - Functions

extension StoryOratorView {
    private func createImageView() {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let folderURL = documentsDirectory.appendingPathComponent("SavedImages")
            
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                let imageFileURLs = fileURLs.filter { fileURL in
                    let fileExtension = fileURL.pathExtension.lowercased()
                    return ["png", "jpg", "jpeg"].contains(fileExtension)
                }
                
                var images: [UIImage] = []
                for fileURL in imageFileURLs {
                    if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                        images.append(image)
                    }
                }
                print("Number of images in local folder: \(imageFileURLs.count)")
                savedImages = images
            } catch {
                print("Error counting images in local folder: \(error)")
            }
        }
    
    private func deleteImage(at index: Int) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsDirectory.appendingPathComponent("SavedImages")
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            let imageFileURLs = fileURLs.filter { fileURL in
                let fileExtension = fileURL.pathExtension.lowercased()
                return ["png", "jpg", "jpeg"].contains(fileExtension)
            }
            
            if index < imageFileURLs.count {
                let fileURLToDelete = imageFileURLs[index]
                try FileManager.default.removeItem(at: fileURLToDelete)
                createImageView() // Refresh savedImages after deletion
            }
        } catch {
            print("Error deleting image: \(error)")
        }
    }
}

struct StoryOratorView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        StoryOratorView(path: $path)
    }
}
