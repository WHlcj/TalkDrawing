
import SwiftUI

struct AnimalsCell: View {
    // 动物图片名称
    let animal: String
    // 动物选择
    @Binding var selectedAnimal: String
    // 上色
    @Binding var selectedColor: Color

    var body: some View {
        Button {
            selectedAnimal = animal
        } label: {
            Image(animal)
                .renderingMode(.template)
                .foregroundColor(selectedAnimal == animal ? selectedColor : .gray)
        }
    }
}

struct AnimalsCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedColor = Color.green
        @State var selectedAnimal = "duck"
        AnimalsCell(animal: "duck",selectedAnimal: $selectedAnimal , selectedColor: $selectedColor)
    }
}
