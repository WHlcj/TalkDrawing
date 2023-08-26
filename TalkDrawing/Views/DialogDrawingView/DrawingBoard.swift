
import SwiftUI
import PencilKit

struct DrawingBoard: UIViewRepresentable {
    // 传入画板
    @Binding var canvas: PKCanvasView
    // 切换画图工具和橡皮擦
    @Binding var isDrawing: Bool
    // 切换画图工具
    @Binding var tool: PKInkingTool.InkType
    // 颜色选择
    @Binding var color: Color
    // 画笔粗细
    @Binding var lineWidth: Double
    
    let eraser = PKEraserTool(.bitmap) // 橡皮擦
    
    var ink: PKInkingTool {
        PKInkingTool(tool, color: UIColor(color), width: lineWidth)
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDrawing ? ink : eraser
    
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.tool = isDrawing ? ink : eraser

    }
}
