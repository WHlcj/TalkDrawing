
import UIKit

class VDDrawBoardView: UIView {
    /// 画笔颜色
    public var lineColor: UIColor = .black
    /// 画笔线条宽度
    public var lineWidth: CGFloat = 4
    
    private var startPoint: CGPoint?
    private var endPoint: CGPoint?
    /// layerList则用于存储每一步的绘制内容，用于后续回退操作
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
    
    /// 回退到上一步绘制的内容
    public func back() {
        if let subLayerList = self.layerList.last {
            for subLayer in subLayerList {
                subLayer.removeFromSuperlayer()
            }
            self.layerList.removeLast()
        }
    }
    
    /// 画板生成图片,调用getImage()方法可以将画板上的内容生成为UIImage对象。
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
    // 设置画板试图
    private func setup() {
        // 确保内容不会超过边界
        self.clipsToBounds = true
        // 添加拖动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        self.addGestureRecognizer(pan)
        // 添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        self.addGestureRecognizer(tap)
    }
    /// @objc private func panAction(_ pan: UIPanGestureRecognizer)是拖动手势的处理方法。当用户开始拖动手势时（.began状态），记录起点和终点坐标，并调用updateLayer()方法进行绘制更新。当用户持续拖动手势时（.changed状态），更新起点和终点坐标，并再次调用updateLayer()方法进行绘制更新。当用户结束拖动手势时（.ended状态），更新起点和终点坐标，并再次调用updateLayer()方法进行绘制更新。同时，将当前绘制内容添加到curLayerList中，并将curLayerList添加到layerList数组中，以便进行回退操作。
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
