
import SwiftUI
import PencilKit

struct draft: View {
    
    // 画板
    @State var canvasOne = PKCanvasView()
    @State var canvasTow = PKCanvasView()
    @State var canvas = PKCanvasView()
    @State var canvasTest = ["何时", "何地", "何人", "何事"]
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
    
    @State var number = 0
    
    var body: some View {
        VStack {
            if index == 0 {
                DrawingBoard(canvas: $canvas, isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
            } else if index == 1 {
                DrawingBoard(canvas: $canvasOne, isDrawing: $isDrawing, tool: $tool, color: $selectedColor, lineWidth: $lineWidth)
            }
            
            Button {
                index = index == 1 ? 0 : 1
            } label: {
                Text("点我")
                    .font(.largeTitle)
            }

        }
        .frame(width: 300, height: 300)
        .background(Color.cyan.frame(width: 310, height: 310))
    }
    
    func increaseNumber() -> Int {

        number += 1
        if number > 3 {
            number = 0
        }
        
        return number
    }

}

struct draft_Previews: PreviewProvider {
    static var previews: some View {
        draft()
    }
}
