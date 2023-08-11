
import SwiftUI

struct ColorCell: View {
    // 绑定的颜色
    @Binding var selectedColor: Color
    // 色块自身颜色
    let color: Color
    
    var body: some View {
        Button {
            selectedColor = color
        } label: {
            Rectangle()
                .fill(color)
                .frame(width: 100, height: 100)
        }
    }
}

struct ColorCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedColor = Color.green
        ColorCell(selectedColor: $selectedColor, color: .cyan)
    }
}
