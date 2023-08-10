import UIKit
import SwiftUI

struct DrawBoardView: UIViewControllerRepresentable {
    
    // APP导航路由
    @Binding var path: NavigationPath
    // 返回上一界面
    @Environment(\.dismiss) var dismiss
    
    let vc = VDDrawBoardVC()
    func makeUIViewController(context: Context) -> some UIViewController {
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
class VDDrawBoardVC: UIViewController {

    var drawBoardView = VDDrawBoardView()
    var whenBoardView = VDDrawBoardView() //何时
    var whereBoardView = VDDrawBoardView() //何地
    var whoBoardView = VDDrawBoardView() //何人
    var whatBoardView = VDDrawBoardView() //何事

    public var colorGroup: [UIColor] = [.red,.yellow,.blue,.orange,.purple,.black,.brown,.darkGray,.green,.white]
    var colorGroupView = UIView()
    
    var clearButton = UIButton()
    
    var backButton = UIButton()
    
    var downloadButton = UIButton()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 4
        slider.maximumValue = 16
        slider.value = 4
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.contents = UIImage(named:"background")?.cgImage
        self.view.addSubview(drawBoardView)
        drawBoardView.backgroundColor = .white.withAlphaComponent(0.7)
        drawBoardView.layout {
            $0.height == 800
            $0.width == 800
            $0.centerX == $0.superview.centerX
            $0.centerY == $0.superview.centerY
        }
        
        self.view.addSubview(colorGroupView)
        setUpColorGroup()
        
        view.addSubview(slider)
        view.addSubview(valueLabel)
        slider.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2) // Rotate picker vertically
        slider.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.layout {
            $0.height == 50
            $0.width == 50
            $0.leading == drawBoardView.trailing + 100
            $0.top == drawBoardView.top
        }
        slider.layout {
            $0.height == 50
            $0.width == 200
            $0.centerX == valueLabel.centerX
            $0.top == valueLabel.bottom + 80
        }
        
        self.view.addSubview(clearButton)
        clearButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        clearButton.imageView?.tintColor = UIColor(.accentColor)
        clearButton.imageView?.layout(using: { view in
            view.height == 100
            view.width == 100
        })
        clearButton.addTarget(self, action: #selector(clearDrawBoard), for: .touchUpInside)
        clearButton.layout {
            $0.leading == $0.superview.leading + 20
            $0.height == 100
            $0.width == 100
            $0.top == drawBoardView.top
        }
        
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
        backButton.imageView?.layout(using: { view in
            view.height == 100
            view.width == 100
        })
        backButton.imageView?.tintColor = UIColor(.accentColor)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.layout {
            $0.leading == $0.superview.leading + 20
            $0.height == 100
            $0.width == 100
            $0.top == clearButton.bottom
        }
        
        self.view.addSubview(downloadButton)
        downloadButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        downloadButton.imageView?.layout(using: { view in
            view.height == 100
            view.width == 100
        })
        downloadButton.imageView?.tintColor = UIColor(.accentColor)
        downloadButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        downloadButton.layout {
            $0.leading == $0.superview.leading + 20
            $0.height == 100
            $0.width == 100
            $0.top == backButton.bottom
        }
    }
    
    func setUpColorGroup() {
        for (index, color) in colorGroup.enumerated() {
            let colorBlock = UIView()
            colorBlock.backgroundColor = color
            colorBlock.isUserInteractionEnabled = true
            self.view.addSubview(colorBlock) // Add the color block to the container view
            colorBlock.layout {
                $0.width == 75
                $0.height == 75
                $0.top == drawBoardView.top + CGFloat(index * 80)
                $0.leading == drawBoardView.trailing + 20 // Align left edge to the left edge of the container
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectColor(_:)))
            colorBlock.addGestureRecognizer(tapGesture)
        }
    }

    
    @objc func clearDrawBoard(_ sender: Any) {
        self.drawBoardView.clear()
    }
    
    @objc func back(_ sender: Any) {
        self.drawBoardView.back()
    }
    @objc func save(_ sender: Any) {
        self.drawBoardView.getImage()
    }
    
    @objc func selectColor(_ sender: UITapGestureRecognizer) {
        self.drawBoardView.lineColor = sender.view?.backgroundColor ?? .black
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        self.drawBoardView.lineWidth = CGFloat(Int(sender.value))
        updateValueLabel()
    }
    
    func updateValueLabel() {
        let value = Int(slider.value)
        valueLabel.text = "\(value)"
    }
    
}
