
import SwiftUI
import PencilKit

struct DialogDrawingView: View {
    // App路由导航
    @Binding var path: NavigationPath
    // 画板
    @State var canvas = PKCanvasView()
    // 默认能够画画
    @State var isDrawing = true
    // 选择的颜色
    @State var selectedColor = Color.green
    // 跳出选色器
    @State var shouldShowAlert = false
    // 画笔类型
    @State var tool = PKInkingTool.InkType.pen
    
    // 当前的区域
    @State var selectedSection = "何时"
    // 区域名称
    let sections = ["何时", "何地", "何人", "何事"]
    
    var body: some View {
        ZStack {
            // background
            Background()
            
            // content
            VStack(spacing: 0) {
                navigationBar
                    .padding()
                    .padding(.horizontal)
                functionBar
                HStack {
                    DrawingBoard(canvas: $canvas, isDrawing: $isDrawing, tool: $tool, color: $selectedColor)
                    ColorChosenSection(selectedColor: $selectedColor)
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
                                .font(.system(size: selectedSection == name ? 25 : 24))
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
        ScrollView {
            ForEach(K.AppIcon.tools, id: \.self) { toolName in
                Button {
                    switch toolName {
                    case "drawingPencil":
                        tool = .pencil
                    case "inkjetPen":
                        tool = .pen
                    case "paintBucket":
                        tool = .marker
                    default:
                        tool = .pen
                        return
                    }
                } label: {
                    Image(toolName)
                }
                .padding(.vertical)
            }
            // 切换到eraser按钮
            Button {
                isDrawing = false
            } label: {
                Image(K.AppIcon.eraser)
            }
            
        }
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
