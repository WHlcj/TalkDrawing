
import UIKit

class VDDrawBoardView: UIView {
        /// 画笔颜色
        public var lineColor: UIColor = .black
        /// 画笔线条宽度
        public var lineWidth: CGFloat = 4
        
        private var startPoint: CGPoint?
        private var endPoint: CGPoint?
        
        private lazy var layerList: [[CALayer]] = {
            return [[CALayer]]()
        }()
        
        private lazy var curLayerList: [CALayer] = {
            return [CALayer]()
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
        
        /// 清空画板
        public func clear() {
            if let subLayers = self.layer.sublayers {
                for subLayer in subLayers {
                    subLayer.removeFromSuperlayer()
                }
            }
            
            self.layerList.removeAll()
        }
        
        /// 回退
        public func back() {
            if let subLayerList = self.layerList.last {
                for subLayer in subLayerList {
                    subLayer.removeFromSuperlayer()
                }
                self.layerList.removeLast()
            }
        }
        
        /// 画板生成图片
        public func getImage() -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        private func setup() {
            self.clipsToBounds = true
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
            self.addGestureRecognizer(pan)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
            self.addGestureRecognizer(tap)
        }
        
        @objc private func panAction(_ pan: UIPanGestureRecognizer) {
            switch pan.state {
            case .began:
                self.startPoint = pan.location(in: self)
                self.endPoint = pan.location(in: self)
                self.updateLayer()
            case .changed, .ended:
                self.startPoint = self.endPoint
                self.endPoint = pan.location(in: self)
                self.updateLayer()
                if pan.state == .ended {
                    self.layerList.append(self.curLayerList)
                    self.curLayerList.removeAll()
                }
            default:
                break
            }
        }
        
        @objc private func tapAction(_ tap: UITapGestureRecognizer) {
            self.startPoint = tap.location(in: self)
            self.endPoint = tap.location(in: self)
            self.updateLayer()
            self.layerList.append(self.curLayerList)
            self.curLayerList.removeAll()
        }
        
        private func updateLayer() {
            let path = UIBezierPath()
            path.move(to: self.startPoint!)
            path.addLine(to: self.endPoint!)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = self.lineWidth
            shapeLayer.strokeColor = self.lineColor.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.path = path.cgPath
            shapeLayer.lineJoin = .round
            shapeLayer.lineCap = .round
            self.curLayerList.append(shapeLayer)
            self.layer.addSublayer(shapeLayer)
        }

}
