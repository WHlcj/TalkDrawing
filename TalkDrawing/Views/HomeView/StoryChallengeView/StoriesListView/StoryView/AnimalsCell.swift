
import SwiftUI

struct AnimalsCell: View {
    // 动物图片名称
    let animal: String
    // 动物选择
    @Binding var selectedAnimal: String
    // 上色
    @Binding var selectedColor: Color
    // 表示视图被拖动的距离
    @State var offset: CGSize = .zero
    // 拖拽到指定位置判断
    @Binding var hasFinishedPlacingAnimal: Bool

    var body: some View {
        //初始化拖动手势
        let dragGesture = DragGesture()
            .onChanged { (value) in
               // print(value.startLocation, value.location, value.translation)
                self.offset = value.translation
            }
            .onEnded { (value) in
                if (abs(value.translation.width) >= 300) {
                    //如果被拖动的视图，距离目标视图的位置较近，则将被拖动的视图，放置在目标视图的位置
//                    self.offset = CGSize(width: 0, height: -3000)
                    self.offset = .zero
                    hasFinishedPlacingAnimal = true
                }
                else {
                    //如果被拖动的视图，距离目标视图的位置较远，则返回原来的位置
                    self.offset = .zero
                }
            }
        
        Button {
            selectedAnimal = animal
            hasFinishedPlacingAnimal = false
        } label: {
            Image(animal)
                .renderingMode(.template)
                .tint(selectedAnimal == animal ? selectedColor : .gray)
                .offset(withAnimation {offset})
                .gesture(dragGesture)
        }
    }
}

struct AnimalsCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedColor = Color.green
        @State var selectedAnimal = "duck"
        @State var hasFinishedPlacingAnimal = false
        AnimalsCell(animal: "duck",selectedAnimal: $selectedAnimal , selectedColor: $selectedColor, hasFinishedPlacingAnimal: $hasFinishedPlacingAnimal)
    }
}
