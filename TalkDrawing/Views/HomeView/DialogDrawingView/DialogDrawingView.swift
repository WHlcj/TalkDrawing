
// TO DO:
// 1.完成finishGame的页面改造和DrawingGame相关的逻辑处理

import SwiftUI
import PencilKit
import SwiftSpeech

struct DialogDrawingView: View {
    // App路由导航
    @Binding var path: NavigationPath
    // DrawingGame的ViewModel
    @StateObject var vm = DrawingGameVM()
    // 画板
    @State var canvases = [PKCanvasView(), PKCanvasView(), PKCanvasView(), PKCanvasView()]
    // 画板index
    @State var index = 0
    // 默认能够画画
    @State var isDrawing = true
    // 选择的颜色
    @State var selectedColor = Color.green
    // 画笔粗细
    @State var lineWidth = 1.0
    // 画笔类型
    @State var tool = PKInkingTool.InkType.pen
    // 语音文本信息
    @State var voiceText = ""
    // 是否正在加载图片
    @State var isLoadingImage = false
    // 弹出sheets
    @State private var showSheets = false
    // 完成游戏弹出VictoryView
    @State private var finishedGame = false
    
    var body: some View {
        ZStack {
            // background
            Background()
            
            // content
            VStack(spacing: 0) {
                // 顶部标题栏
                NavigationBar(image: K.AppIcon.HomeItemPencil, title: "语音日记式涂鸦")
                // 粉色区域功能栏
                DrawingFunctionBar(vm: vm, canvases: $canvases, index: $index, showSheets: $showSheets, finishedGame: $finishedGame)
                HStack {
                    // 画板
                    drawingBoard
                    // 画板右侧工具区
                    toolChooseSection
                }
            }
            // 保存图片成功提醒
            if showSheets {
                TextAlert(text: "图片保存成功", boolValue: $showSheets)
            }
            // 完成游戏动画
            if finishedGame {
                VictoryView(path: $path, number: 4, title: "生成连环画") {
                    saveComics()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


// MARK: - Componenrts
extension DialogDrawingView {
    /// 画板
    var drawingBoard: some View {
        VStack {
            switch index {
            case 0:
                DrawingBoard(canvas: $canvases[0], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
            case 1:
                DrawingBoard(canvas: $canvases[1], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
            case 2:
                DrawingBoard(canvas: $canvases[2], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
            case 3:
                DrawingBoard(canvas: $canvases[3], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
            default:
                DrawingBoard(canvas: $canvases[0], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
            }
        }
    }
    /// 涂鸦颜色和画笔粗细调整区
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
                DrawingTools(isDrawing: $isDrawing, tool: $tool, voiceText: $voiceText)
            }
            voiceToImageSection
        }
        .padding(.top)
    }
    /// 语音生成图片区
    var voiceToImageSection: some View {
        VStack {
            AsyncImage(url: URL(string: vm.img)) { image in
                image
                    .resizable()
                    .overlay(Text(voiceText))
                    .aspectRatio(1, contentMode: .fit)
            } placeholder: {
                if isLoadingImage {
                    Color.clear.opacity(0.3)
                        .overlay(ProgressView().scaleEffect(1.2))
                        .aspectRatio(1, contentMode: .fit)
                } else {
                    Color.gray.opacity(0.3)
                        .overlay(Text(voiceText == "" ? "按住语言按钮说话" : voiceText))
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .onTapGesture {
                if voiceText != "" {
                    vm.fetchImage(text: voiceText)
                    voiceText = ""
                }
            }
        }
        .padding(.bottom)
    }
}

// MARK: - Functions
extension DialogDrawingView {
    /// 保存连环画
    private func saveComics() {
        let img1 = Image(uiImage: self.canvases[0].drawing.image(from: canvases[0].bounds, scale: 1))
        let img2 = Image(uiImage: self.canvases[1].drawing.image(from: canvases[1].bounds, scale: 1))
        let img3 = Image(uiImage: self.canvases[2].drawing.image(from: canvases[2].bounds, scale: 1))
        let img4 = Image(uiImage: self.canvases[3].drawing.image(from: canvases[3].bounds, scale: 1))
        var comics: some View {
            VStack {
                HStack {
                    img1
                    img2
                }
                HStack {
                    img3
                    img4
                }
            }
        }
        
        if !showSheets {
            comics.snapshot()
            withAnimation(.easeInOut) {
                self.showSheets = true
            }
            // 防止警告弹窗常驻
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut) {
                    self.showSheets = false
                }
            }
        }
    }
}


struct DialogDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        DialogDrawingView(path: $path)
    }
}
