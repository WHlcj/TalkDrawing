
import SwiftUI
import PencilKit

struct DrawingFunctionBar: View {
    // DrawingGame的ViewModel
    @ObservedObject var vm: DrawingGameVM
    // 画板
    @Binding var canvases: [PKCanvasView]
    // 画板index
    @Binding var index: Int
    // 弹出sheets
    @Binding var showSheets: Bool
    // 完成游戏弹出VictoryView
    @Binding var finishedGame: Bool
    
    var body: some View {
        HStack {
            Spacer()
            sectionChooseSection
            Spacer()
            Spacer()
            Spacer()
            buttonsSection
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Rectangle().fill(K.AppColor.ThemeColor).opacity(0.4))
        .onAppear {
            vm.playVoice(vm.canvas[0])
        }
    }
}

extension DrawingFunctionBar {
    var sectionChooseSection: some View {
        HStack(spacing: 0) {
            ForEach(vm.canvas, id: \.self) { item in
                Button {
                    index = vm.canvas.firstIndex(of: item)!
                    vm.stopVoice()
                    vm.playVoice(vm.canvas[index])
                } label: {
                    Rectangle()
                        .fill(K.AppColor.ThemeButtonColor)
                        .frame(width: 56, height: 56)
                        .opacity(index == vm.canvas.firstIndex(of: item) ? 1 : 0.6)
                        .overlay {
                            Text(item)
                                .font(.system(size: index == vm.canvas.firstIndex(of: item) ? 25 : 20))
                                .bold(index == vm.canvas.firstIndex(of: item))
                                .foregroundColor(.white)
                        }
                }
            }
        }
    }

    var buttonsSection: some View {
        HStack {
            // 清空按钮
            CustomButton(image: K.AppIcon.trashbin) { canvases[index].drawing = PKDrawing() }
            // 图片保存本地按钮
            CustomButton(image: K.AppIcon.download) { saveImage() }
            // 跳转下一区域按钮
            CustomButton(image: K.AppIcon.rightArrow) { increaseIndex() }
        }
    }
    
    struct CustomButton: View {
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

// MARK: - Functions
extension DrawingFunctionBar {

    private func saveImage() {
        if !showSheets {
            UIImageWriteToSavedPhotosAlbum(canvases[index].drawing.image(from: canvases[index].bounds, scale: 1), nil, nil, nil)
            withAnimation(.easeInOut) {
                self.showSheets = true
            }
            // 防止警告弹窗常驻
            delay(by: 2) {
                withAnimation(.easeInOut) {
                    self.showSheets = false
                }
            }
        }
    }

    private func increaseIndex() {
        // 这样写才能实现index = 0时显性跳转到"何时"
        if index < vm.canvas.count - 1 {
            index += 1
            vm.playVoice(vm.canvas[index])
        } else {
            vm.stopVoice() // 暂停播放声音
            finishedGame = true
        }
    }
}

struct DrawingFunctionBar_Previews: PreviewProvider {
    static var previews: some View {
        // DrawingGame的ViewModel
        @StateObject var vm = DrawingGameVM()
        // 画板
        @State var canvases = [PKCanvasView(), PKCanvasView(), PKCanvasView(), PKCanvasView()]
        // 画板index
        @State var index = 0
        // 弹出sheets
        @State var showSheets = false
        // 完成游戏弹出VictoryView
        @State var finishedGame = false
        DrawingFunctionBar(vm: vm, canvases: $canvases, index: $index, showSheets: $showSheets, finishedGame: $finishedGame)
    }
}
