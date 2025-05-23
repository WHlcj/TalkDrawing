
import SwiftUI

struct ScoreBoard: View {
    
    var scores: [Int]
    
    var body: some View {
        VStack {
            ZStack {
                Image(K.AppIcon.scoreBoard)
                
                GeometryReader { geometry in
                    let centerX = geometry.size.width / 2
                    let centerY = geometry.size.height / 2
                    
                    let topPoint = CGPoint(x: centerX, y: centerY - CGFloat(scores[0] * 20))
                    let rightPoint = CGPoint(x: centerX + CGFloat(scores[3] * 20), y: centerY)
                    let bottomPoint = CGPoint(x: centerX, y: centerY + CGFloat(scores[1] * 20))
                    let leftPoint = CGPoint(x: centerX - CGFloat(scores[2] * 20), y: centerY)
                    Path { path in
                        path.move(to: topPoint)
                        path.addLine(to: rightPoint)
                        path.addLine(to: bottomPoint)
                        path.addLine(to: leftPoint)
                        path.closeSubpath()
                    }
                    .stroke(lineWidth: 5) // 设置连线宽度
                    .foregroundColor(K.AppColor.ThemeColor)
                    
                    CirclePoint(point: topPoint)
                    CirclePoint(point: rightPoint)
                    CirclePoint(point: bottomPoint)
                    CirclePoint(point: leftPoint)
                }
            }
            .frame(width: 460, height: 460)
        }
    }

    struct CirclePoint: View {
        var point: CGPoint
        
        var body: some View {
            Circle()
                .frame(width: 20, height: 20) // 设置小圆的大小
                .foregroundColor(K.AppColor.ThemeColor.opacity(0.7)) // 设置小圆的颜色
                .position(point)
        }
    }
}

struct ScoreBoard_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoard(scores: [6,6,6,6])
    }
}
