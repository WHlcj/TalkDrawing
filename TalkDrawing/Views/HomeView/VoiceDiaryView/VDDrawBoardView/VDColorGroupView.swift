
import UIKit

protocol VDColorGroupViewDelegate: AnyObject {
    func didSelectColor(_ color: UIColor, lineWidth: CGFloat)
}


class VDColorGroupView: UIView {

    weak var delegate: VDColorGroupViewDelegate?
    
    public var colorGroup: [UIColor] = [.red,.yellow,.blue,.orange,.purple,.black,.brown,.darkGray,.green,.white]
    var colorBlocks: [UIView] = [] // Add the colorBlocks array here
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        for (index, color) in colorGroup.enumerated() {
            let colorBlock = UIView()
            colorBlock.backgroundColor = color
            colorBlock.isUserInteractionEnabled = true
            addSubview(colorBlock)
            colorBlock.layout {
                $0.width == 75
                $0.height == 75
                $0.top == $0.superview.top + CGFloat(index * 80)
            }
            colorBlocks.append(colorBlock) // Store the colorBlocks in the array
//            colorBlock.tag = index + 1 // Set a tag for each color block (this will be used as the line width)
            
             //Add tap gesture recognizer to each color block
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorBlockTapped(_:)))
            colorBlock.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func colorBlockTapped(_ sender: UITapGestureRecognizer) {
          guard let colorBlock = sender.view, let index = colorBlocks.firstIndex(of: colorBlock) else {
              return
          }
        
          let selectedColor = colorGroup[index]
//          let lineWidth = CGFloat(index + 1)
          delegate?.didSelectColor(selectedColor, lineWidth: CGFloat(5))
      }
}

