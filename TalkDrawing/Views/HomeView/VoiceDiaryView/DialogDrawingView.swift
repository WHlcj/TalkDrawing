
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
    // sheets
    @State private var showSheets = false
    
    var body: some View {
        ZStack {
            // background
            Background()
            
            // content
            VStack(spacing: 0) {
                // 顶部标题栏
                navigationBar
                    .padding()
                    .padding(.horizontal)
                // 粉色区域功能栏
                functionBar
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
        }
        .navigationBarBackButtonHidden(true)
    }
}


// MARK: - Componenrts
extension DialogDrawingView {
    /// 自定义导航栏
    var navigationBar: some View {
        HStack {
            BackButton()
            Spacer()
            HomeItem(image: K.AppIcon.HomeItemPencil, title: "语音日记式涂鸦")
            Spacer()
            SettingButton(path: $path)
        }
        .frame(maxWidth: .infinity)
    }
    /// 自定义功能栏
    var functionBar: some View {
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
    }
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
    /// 情景选择区
    var sectionChooseSection: some View {
        HStack(spacing: 0) {
            ForEach(vm.canvas, id: \.self) { item in
                Button {
                    index = vm.canvas.firstIndex(of: item)!
                } label: {
                    Rectangle()
                        .fill(K.AppColor.ThemeColor)
                        .frame(width: 56, height: 56)
                        .opacity(index == vm.canvas.firstIndex(of: item) ? 1 : 0.6)
                        .overlay {
                            Text(item)
                                .font(.system(size: index == vm.canvas.firstIndex(of: item) ? 23 : 20))
                                .bold(index == vm.canvas.firstIndex(of: item))
                                .foregroundColor(.white)
                        }
                }
            }
        }
    }
    /// 功能按键区
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
                drawingTools
            }
            voiceToImageSection
        }
        .padding(.top)
    }
    /// 涂鸦工具选择栏
    var drawingTools: some View {
        VStack(spacing: 20) {
            ForEach(K.AppIcon.tools, id: \.self) { toolName in
                Button {
                    switch toolName {
                    case "drawingPencil":
                        isDrawing = true
                        tool = .pencil
                    case "inkjetPen":
                        isDrawing = true
                        tool = .pen
                    case "paintBucket":
                        isDrawing = true
                        tool = .marker
                    default:
                        isDrawing = true
                        tool = .pen
                        return
                    }
                } label: {
                    Image(toolName)
                }
            }
            // 切换到eraser按钮
            Button {
                isDrawing = false
            } label: {
                Image(K.AppIcon.eraser)
            }
            SwiftSpeech.RecordButton()
                .swiftSpeechRecordOnHold(locale: Locale(identifier: "zh-CN"))
                .onRecognizeLatest(update: $voiceText)
                .onAppear {
                    SwiftSpeech.requestSpeechRecognitionAuthorization()
                }
                .frame(width: 80, height: 80)
                .scaleEffect(0.8)
        }
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
    /// 保存图片到本地
    private func saveImage() {
        if !showSheets {
            UIImageWriteToSavedPhotosAlbum(canvases[index].drawing.image(from: canvases[index].bounds, scale: 1), nil, nil, nil)
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
    /// index计数+1
    private func increaseIndex() {
        index += 1
        if index > vm.canvas.count {
            index = 0
        }
    }
}


struct DialogDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        DialogDrawingView(path: $path)
    }
}
