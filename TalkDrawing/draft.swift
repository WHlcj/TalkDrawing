
import SwiftUI
import PencilKit
import SwiftSpeech

struct draft: View {

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
    @State private var testBool = false
    
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
//                    if testBool {
//                        comics
//                    } else {
//                        DrawingBoard(canvas: $canvases[0], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
//                            .aspectRatio(1.25, contentMode: .fit)
//                    }
                    comics
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
extension draft {
    var comics: some View {
        VStack {
            HStack {
                DrawingBoard(canvas: $canvases[0], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
                DrawingBoard(canvas: $canvases[1], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
            }
            HStack {
                DrawingBoard(canvas: $canvases[2], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
                DrawingBoard(canvas: $canvases[3], isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
            }
        }
    }
    /// 自定义功能栏
    var functionBar: some View {
        HStack {
            Spacer()
            sectionChooseSection
            Spacer()
            Spacer()
            Spacer()
            HStack {
                // 清空按钮
                CustomButton(image: K.AppIcon.trashbin) {
                    canvases[index].drawing = PKDrawing()
                }
                // 跳转下一区域按钮
                CustomButton(image: K.AppIcon.rightArrow) { saveComics() }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Rectangle().fill(K.AppColor.ThemeColor).opacity(0.4))
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
}

// MARK: - Functions
extension draft {
    private func saveComics() {
        
        let img1 = Image(uiImage: self.canvases[0].drawing.image(from: canvases[0].bounds, scale: 1))

        let img2 = Image(uiImage: self.canvases[1].drawing.image(from: canvases[1].bounds, scale: 1))

        let img3 = Image(uiImage: self.canvases[2].drawing.image(from: canvases[2].bounds, scale: 1))

        let img4 = Image(uiImage: self.canvases[3].drawing.image(from: canvases[3].bounds, scale: 1))
        
        var c: some View {
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
        c.snapshot()
    }
    /// 自定义导航栏
    var navigationBar: some View {
        HStack {
            BackButton()
            Spacer()
            HomeItem(image: K.AppIcon.HomeItemPencil, title: "语音日记式涂鸦")
            Spacer()
        }
        .frame(maxWidth: .infinity)
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
                ColorValueSlider(value: $lineWidth)
                        .frame(width: 50, height: 300)
                drawingTools
            }
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

        }
    }
}


struct draft_Previews: PreviewProvider {
    static var previews: some View {
        draft()
    }
}
