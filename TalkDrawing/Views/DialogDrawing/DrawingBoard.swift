
import SwiftUI
import PencilKit

struct DrawingBoard: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var isDrawing: Bool
    @Binding var drawingTool: PKInkingTool.InkType
    @Binding var color: Color
    @Binding var lineWidth: Double
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: DrawingBoard
        var isUpdating = false
        
        init(_ parent: DrawingBoard) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard !isUpdating else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.isUpdating = true
                self?.parent.drawing = canvasView.drawing
                self?.isUpdating = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.delegate = context.coordinator
        canvas.drawing = drawing
        canvas.drawingPolicy = .anyInput
        canvas.tool = currentTool
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if !context.coordinator.isUpdating && uiView.drawing != drawing {
            uiView.drawing = drawing
        }
        uiView.tool = currentTool
    }
    
    private var currentTool: PKTool {
        isDrawing ?
            PKInkingTool(drawingTool, color: UIColor(color), width: lineWidth) :
            PKEraserTool(.bitmap)
    }
}
