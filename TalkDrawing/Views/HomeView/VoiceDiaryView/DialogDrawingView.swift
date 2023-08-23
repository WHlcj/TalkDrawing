
import SwiftUI
import PencilKit
import SwiftSpeech

struct DialogDrawingView: View {
    // App路由导航
    @Binding var path: NavigationPath
    // DrawingGame的ViewModel
    @StateObject var vm = DrawingGameVM()
    // 画板
    @State var canvas = PKCanvasView()
    // 默认能够画画
    @State var isDrawing = true
    // 选择的颜色
    @State var selectedColor = Color.green
    // 画笔粗细
    @State var lineWidth = 1.0
    // 跳出选色器
    @State var shouldShowAlert = false
    // 画笔类型
    @State var tool = PKInkingTool.InkType.pen
    // 当前的区域
    @State var selectedSection = "何时"
    // 区域名称
    let sections = ["何时", "何地", "何人", "何事"]
    // 语音文本信息
    @State var voiceText = ""
    // 是否正在加载图片
    @State var isLoadingImage = false
    
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
                    DrawingBoard(canvas: $canvas, isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
                    // 工具栏
                    toolChooseSection
                }
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
    /// 自定义工具栏下的区域选择区
    var sectionChooseSection: some View {
        HStack(spacing: 0) {
            ForEach( sections, id: \.self) { name in
                Button {
                    selectedSection = name
                } label: {
                    Rectangle()
                        .fill(K.AppColor.ThemeColor)
                        .frame(width: 64, height: 64)
                        .opacity(selectedSection == name ? 1 : 0.6)
                        .overlay {
                            Text(name)
                                .font(.system(size: selectedSection == name ? 23 : 20))
                                .bold(selectedSection == name)
                                .foregroundColor(.white)
                        }
                }
            }
        }
    }
    /// 自定义工具栏下的按钮区
    var buttonsSection: some View {
        HStack {
            // 清空按钮
            Button {
                canvas.drawing = PKDrawing()
            } label: {
                Image(K.AppIcon.trashbin)
            }
            // 图片保存本地按钮
            Button {
                saveImage()
            } label: {
                Image(K.AppIcon.download)
            }
            // 跳转下一区域按钮
            Button {
                
            } label: {
                Image(K.AppIcon.rightArrow)
                    .resizable()
                    .frame(width: 64, height: 64)
            }
        }
    }
    /// 工具选择栏
    var toolChooseSection: some View {
        VStack {
            HStack(alignment: .top,spacing: 0) {
                VStack {
                    ColorValueSlider(value: $lineWidth)
                        .frame(width: 50, height: 300)
                    ColorPicker(selection: $selectedColor) {}
                        .frame(width: 50,height: 50)
                        .offset(x: -10)
                    
                }
                drawingTools
            }
            voiceToImageSection
        }
        .padding(.top)
    }
    /// 画图工具栏
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
        UIImageWriteToSavedPhotosAlbum(canvas.drawing.image(from: canvas.bounds, scale: 1), nil, nil, nil)
    }
}


struct DialogDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        DialogDrawingView(path: $path)
    }
}
