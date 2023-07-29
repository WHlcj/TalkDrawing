
import UIKit
import SwiftUI

struct DrawBoardView: UIViewControllerRepresentable {
    
    let vc = VDDrawBoardVC()
    func makeUIViewController(context: Context) -> some UIViewController {
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
class VDDrawBoardVC: UIViewController {

    var drawBoardView = VDDrawBoardView()
        
    public var colorGroup: [UIColor] = [.red,.yellow,.blue,.orange,.purple,.black,.brown,.darkGray,.green,.white]
    var colorGroupView = UIView()
    
    var clearButton = UIButton()
    
    var backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.contents = UIImage(named:"background")?.cgImage
        self.view.addSubview(drawBoardView)
        drawBoardView.backgroundColor = .lightGray
        drawBoardView.layout {
            $0.height == 800
            $0.width == 800
            $0.centerX == $0.superview.centerX
            $0.centerY == $0.superview.centerY
        }
        
        self.view.addSubview(colorGroupView)
        setUpColorGroup()
        
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
    
    @objc func selectColor(_ sender: UITapGestureRecognizer) {
        self.drawBoardView.lineColor = sender.view?.backgroundColor ?? .black
    }
    
}
