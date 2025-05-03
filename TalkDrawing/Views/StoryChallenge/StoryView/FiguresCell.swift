
import SwiftUI

struct FiguresCell: View {
    let image: String
    // 动物选择
    @Binding var selectedFigure: String
    // 上色
    @Binding var selectedColor: Color
    // 表示视图被拖动的距离
    @State var offset: CGSize = .zero
    // 拖拽到指定位置判断
    @Binding var gestureFlag: Bool

    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { (value) in
               // print(value.startLocation, value.location, value.translation)
                self.offset = value.translation
            }
            .onEnded { (value) in
                if (abs(value.translation.width) >= 300) {
                    self.offset = .zero
                    //hasFinishedPlacingAnimal = true
                    self.gestureFlag.toggle()
                }
                else {
                    //如果被拖动的视图，距离目标视图的位置较远，则返回原来的位置
                    self.offset = .zero
                }
                
            }
        
        Button {
            selectedFigure = self.image
        } label: {
            Image(self.image)
                .renderingMode(.template)
                .tint(selectedFigure == self.image ? selectedColor : .gray)
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
        FiguresCell(image: "duck",selectedFigure: $selectedAnimal , selectedColor: $selectedColor, gestureFlag: $hasFinishedPlacingAnimal)
    }
}
