import SwiftUI
import PencilKit

struct DialogDrawingView: View {
    @StateObject var vm = DrawingGameVM.shared
    
    @State private var drawings = [PKDrawing(), PKDrawing(), PKDrawing(), PKDrawing()]
    @State var canvaseIndex = 0
    @State var isDrawing = true
    @State var selectedColor = Color.green
    @State var lineWidth = 1.0
    @State var drawingTool = PKInkingTool.InkType.pen
    
    @State var voiceText = ""
    @State var isLoadingImage = false
    
    var body: some View {
        ZStack {
            TDThemeBackground()
            
            VStack(spacing: 0) {
                TDThemeNavigationBar(image: K.AppIcon.HomeItemPencil, title: "语音日记式涂鸦")
                DrawingFunctionBar(drawings: $drawings, canvaseIndex: $canvaseIndex)
                
                HStack {
                    DrawingBoard(
                        drawing: $drawings[self.canvaseIndex],
                        isDrawing: $isDrawing,
                        drawingTool: $drawingTool,
                        color: $selectedColor,
                        lineWidth: $lineWidth
                    )
                    .id("DrawingBoard_\(self.canvaseIndex)")
                    
                    toolChooseSection
                }
            }
        }
    }
}

extension DialogDrawingView {
    var toolChooseSection: some View {
        VStack {
            HStack(alignment: .top,spacing: -10) {
                VStack {
                    ColorValueSlider(value: $lineWidth)
                        .frame(width: 50, height: 300)
                    ColorPicker(selection: $selectedColor) {}
                        .frame(width: 50,height: 50)
                        .offset(x: -15)
                }
                DrawingTools(isDrawing: $isDrawing, drawingTool: $drawingTool, voiceText: $voiceText)
            }
            voiceToImageSection
        }
        .padding(.top)
    }

    var voiceToImageSection: some View {
        VStack {
            Group {
                if let url = URL(string: vm.imgUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.3)
                                .overlay(
                                    Text(voiceText == "" ? "按住上方语言按钮说话,说完后点击我可生成图片" : "正在加载图片...")
                                )
                                .aspectRatio(1, contentMode: .fit)
                        case .success(let image):
                            image
                                .resizable()
                                .overlay(Text(voiceText))
                                .aspectRatio(1, contentMode: .fit)
                        case .failure(let error):
                            Color.gray.opacity(0.3)
                                .overlay(
                                    VStack {
                                        Text("图片加载失败，请重试")
                                        Text(error.localizedDescription)
                                            .font(.caption)
                                    }
                                )
                                .aspectRatio(1, contentMode: .fit)
                        @unknown default:
                            Color.gray.opacity(0.3)
                                .overlay(Text("未知状态"))
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                } else {
                    Color.gray.opacity(0.3)
                        .overlay(
                            Text(voiceText == "" ? "按住上方语言按钮说话,说完后点击我可生成图片" : voiceText)
                        )
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .onTapGesture {
                if voiceText != "" {
                    vm.fetchImage(text: voiceText)
                    voiceText = "等待中..."
                }
            }
        }
        .padding(.bottom)
    }
}

struct DialogDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DialogDrawingView()
    }
}
