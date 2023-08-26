
import SwiftUI
import PencilKit
import SwiftSpeech

/// 画图工具
struct DrawingTools: View {
    // 画笔和橡皮擦切换
    @Binding var isDrawing: Bool
    // 画图工具
    @Binding var tool: PKInkingTool.InkType
    // 语音文本
    @Binding var voiceText: String
    
    var body: some View {
        /// 涂鸦工具选择栏
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
}

struct DrawingTools_Previews: PreviewProvider {
    static var previews: some View {
        // 画笔和橡皮擦切换
        @State var isDrawing = true
        // 画图工具
        @State var tool: PKInkingTool.InkType = .pen
        // 语音文本
        @State var voiceText: String = ""
        
        DrawingTools(isDrawing: $isDrawing, tool: $tool, voiceText: $voiceText)
    }
}
