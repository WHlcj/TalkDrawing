
import SwiftUI
import PencilKit

struct DrawingFunctionBar: View {
    @Binding var drawings: [PKDrawing]
    @Binding var canvaseIndex: Int
    
    var body: some View {
        HStack {
            sceneChooseSection
            Spacer()
            buttonsSection
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .background(Rectangle().fill(K.AppColor.ThemeColor).opacity(0.4))
        .onAppear {
            AudioManager.shared.playSound(DrawingGameVM.shared.canvas[0])
        }
        .navigationDestination(for: String.self) { destination in
            if destination == "VictoryView" {
                VictoryView(soundName: "B-完成", starNumber: 4, title: "生成连环画") {
                    self.saveComics()
                }
            }
        }
    }
}

extension DrawingFunctionBar {
    var sceneChooseSection: some View {
        HStack(spacing: 0) {
            ForEach(DrawingGameVM.shared.canvas, id: \.self) { item in
                Button {
                    self.canvaseIndex = DrawingGameVM.shared.canvas.firstIndex(of: item)!
                    AudioManager.shared.stopSound()
                    AudioManager.shared.playSound(DrawingGameVM.shared.canvas[self.canvaseIndex])
                } label: {
                    Rectangle()
                        .fill(K.AppColor.ThemeButtonColor)
                        .frame(width: 56, height: 56)
                        .opacity(self.canvaseIndex == DrawingGameVM.shared.canvas.firstIndex(of: item) ? 1 : 0.6)
                        .overlay {
                            Text(item)
                                .font(.system(size: self.canvaseIndex == DrawingGameVM.shared.canvas.firstIndex(of: item) ? 25 : 20))
                                .bold(self.canvaseIndex == DrawingGameVM.shared.canvas.firstIndex(of: item))
                                .foregroundColor(.white)
                        }
                }
            }
        }
    }

    var buttonsSection: some View {
        HStack {
            DrawingFunctionBarButton(image: K.AppIcon.trashbin) {
                self.drawings[self.canvaseIndex] = PKDrawing()
            }
            DrawingFunctionBarButton(image: K.AppIcon.download) { saveImage() }
            DrawingFunctionBarButton(image: K.AppIcon.rightArrow) { increaseIndex() }
        }
    }
    
    struct DrawingFunctionBarButton: View {
        let image: String
        var action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                Image(image)
                    .resizable()
                    .frame(width: image == K.AppIcon.trashbin ? 48 : 56, height: image == K.AppIcon.trashbin ? 48 : 56)
            }
        }
    }
}

extension DrawingFunctionBar {
    private func saveImage() {
        let rect = CGRect(x: 0, y: 0, width: 960, height: 600)
        UIImageWriteToSavedPhotosAlbum(self.drawings[self.canvaseIndex].image(from: rect, scale: 1), nil, nil, nil)
        TDToast.show("图片保存成功！")
    }

    private func increaseIndex() {
        if self.canvaseIndex < DrawingGameVM.shared.canvas.count - 1 {
            self.canvaseIndex += 1
            AudioManager.shared.playSound(DrawingGameVM.shared.canvas[self.canvaseIndex])
        } else {
            AudioManager.shared.stopSound()
            NavigationManager.shared.path.append("VictoryView")
        }
    }
    
    private func saveComics() {
        let rect = CGRect(x: 0, y: 0, width: 960, height: 600)
        var comics: some View {
            VStack {
                HStack {
                    Image(uiImage: self.drawings[0].image(from: rect, scale: 1))
                    Image(uiImage: self.drawings[1].image(from: rect, scale: 1))
                }
                HStack {
                    Image(uiImage: self.drawings[2].image(from: rect, scale: 1))
                    Image(uiImage: self.drawings[3].image(from: rect, scale: 1))
                }
            }
        }
        
        comics.snapshot()
        let controller = UIHostingController(rootView: comics)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        let image = renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        DrawingGameVM.shared.saveComics(images: [image])
        TDToast.show("连环画保存成功！")
    }
}

struct DrawingFunctionBar_Previews: PreviewProvider {
    static var previews: some View {
        @State var drawings = [PKDrawing(), PKDrawing(), PKDrawing(), PKDrawing()]
        @State var index = 0
        @State var showSheets = false
        DrawingFunctionBar(drawings: $drawings, canvaseIndex: $index)
    }
}
