
import SwiftUI

struct FiguresCell: View {
    // 动物图片名称
    let figure: String
    // 动物选择
    @Binding var selectedFigure: String
    // 上色
    @Binding var selectedColor: Color
    // 表示视图被拖动的距离
    @State var offset: CGSize = .zero
    // 拖拽到指定位置判断
    @Binding var gestureFlag: Bool

    var body: some View {
        //初始化拖动手势
        let dragGesture = DragGesture()
            .onChanged { (value) in
               // print(value.startLocation, value.location, value.translation)
                self.offset = value.translation
            }
            .onEnded { (value) in
                if (abs(value.translation.width) >= 300) {
                    self.offset = .zero
                    //hasFinishedPlacingAnimal = true
                    gestureFlag.toggle()
                }
                else {
                    //如果被拖动的视图，距离目标视图的位置较远，则返回原来的位置
                    self.offset = .zero
                }
                
            }
        
        Button {
            selectedFigure = figure
        } label: {
            Image(figure)
                .renderingMode(.template)
                .tint(selectedFigure == figure ? selectedColor : .gray)
                .offset(withAnimation {offset})
                .gesture(dragGesture)
        }
    }
}

struct FiguresCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedColor = Color.green
        @State var selectedAnimal = "duck"
        @State var hasFinishedPlacingAnimal = false
        FiguresCell(figure: "duck",selectedFigure: $selectedAnimal , selectedColor: $selectedColor, gestureFlag: $hasFinishedPlacingAnimal)
    }
}
