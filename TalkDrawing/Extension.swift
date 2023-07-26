//
//  Extension.swift
//  TalkDrawing
//
//  Created by 何纪栋 on 2023/7/26.
//
    
import Foundation
import UIKit

// MARK: - LayoutAnchor
public
protocol LayoutAnchor {
    func constraint(equalTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: LayoutAnchor {}

// MARK: - LayoutDimension
public
protocol LayoutDimension {
    func constraint(equalToConstant float: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualToConstant float: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualToConstant float: CGFloat) -> NSLayoutConstraint

    func constraint(equalTo anchor: Self,
                    multiplier mul: CGFloat,
                    constant float: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self,
                    multiplier mul: CGFloat,
                    constant float: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self,
                    multiplier mul: CGFloat,
                    constant float: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutDimension: LayoutDimension {}
public
struct LayoutAnchorProperty<Anchor: LayoutAnchor> {
    fileprivate let anchor: Anchor
}
public
struct LayoutDimensionProperty<Anchor: LayoutDimension> {
    fileprivate let anchor: Anchor
}

// MARK: - Property
extension LayoutAnchorProperty {
    func equal(to otherAnchor: Anchor, offsetBy
               constant: CGFloat = 0) {
        anchor.constraint(equalTo: otherAnchor,
                          constant: constant).isActive = true
    }

    func greaterThanOrEqual(to otherAnchor: Anchor,
                            offsetBy constant: CGFloat = 0) {
        anchor.constraint(greaterThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }

    func lessThanOrEqual(to otherAnchor: Anchor,
                         offsetBy constant: CGFloat = 0) {
        anchor.constraint(lessThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }
}

extension LayoutDimensionProperty {
    func equal(to constant: CGFloat = 0) {
        anchor.constraint(equalToConstant: constant).isActive = true
    }

    func greaterThanOrEqual(to constant: CGFloat = 0) {
        anchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }

    func lessThanOrEqual(to constant: CGFloat = 0) {
        anchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    }

    func equal(to otherAnchor: Anchor, multiplier mul: CGFloat = 1.0, constant con: CGFloat = 0.0) {
        anchor.constraint(equalTo: otherAnchor, multiplier: mul, constant: con).isActive = true
    }

    func greaterThanOrEqual(to otherAnchor: Anchor, multiplier mul: CGFloat = 1.0, constant con: CGFloat = 0.0) {
        anchor.constraint(greaterThanOrEqualTo: otherAnchor, multiplier: mul, constant: con).isActive = true
    }

    func lessThanOrEqual(to otherAnchor: Anchor, multiplier mul: CGFloat = 1.0, constant con: CGFloat = 0.0) {
        anchor.constraint(lessThanOrEqualTo: otherAnchor, multiplier: mul, constant: con).isActive = true
    }
}

// MARK: - LayoutProxy
public
class LayoutProxy {
    public
    lazy var leading = anchorProperty(with: view.leadingAnchor)
    public
    lazy var trailing = anchorProperty(with: view.trailingAnchor)
    public
    lazy var top = anchorProperty(with: view.topAnchor)
    public
    lazy var bottom = anchorProperty(with: view.bottomAnchor)
    public
    lazy var centerX = anchorProperty(with: view.centerXAnchor)
    public
    lazy var centerY = anchorProperty(with: view.centerYAnchor)
    public
    lazy var width = dimensionProperty(with: view.widthAnchor)
    public
    lazy var height = dimensionProperty(with: view.heightAnchor)

    private let view: UIView
    public
    var superview: UIView {
        assert(view.superview != nil, "need superview!!!")
        return view.superview!
    }

    fileprivate init(view: UIView) {
        self.view = view
    }

    private func anchorProperty<A: LayoutAnchor>(with anchor: A) -> LayoutAnchorProperty<A> {
        return LayoutAnchorProperty(anchor: anchor)
    }
    private func dimensionProperty<B: LayoutDimension>(with anchor: B) -> LayoutDimensionProperty<B> {
        return LayoutDimensionProperty(anchor: anchor)
    }
}

public
extension UIView {
    var leading: NSLayoutXAxisAnchor {
       return self.leadingAnchor
    }
    var trailing: NSLayoutXAxisAnchor {
        return self.trailingAnchor
    }
    var top: NSLayoutYAxisAnchor {
        return self.topAnchor
    }
    var bottom: NSLayoutYAxisAnchor {
        return self.bottomAnchor
    }
    var centerX: NSLayoutXAxisAnchor {
        return self.centerXAnchor
    }
    var centerY: NSLayoutYAxisAnchor {
        return self.centerYAnchor
    }
    var width: NSLayoutDimension {
        return self.widthAnchor
    }
    var height: NSLayoutDimension {
        return self.heightAnchor
    }
    func layout(using closure: (LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(LayoutProxy(view: self))
    }

    func removeAllConstraintsInSuperView() {
        let constraints = superview?
            .constraints
            .filter { $0.firstItem as? UIView  == self } ?? []
        superview?.removeConstraints(constraints)
    }
}

public
extension UILayoutGuide {
    var leading: NSLayoutXAxisAnchor {
       return self.leadingAnchor
    }
    var trailing: NSLayoutXAxisAnchor {
        return self.trailingAnchor
    }
    var top: NSLayoutYAxisAnchor {
        return self.topAnchor
    }
    var bottom: NSLayoutYAxisAnchor {
        return self.bottomAnchor
    }
    var centerX: NSLayoutXAxisAnchor {
        return self.centerXAnchor
    }
    var centerY: NSLayoutYAxisAnchor {
        return self.centerYAnchor
    }
    var width: NSLayoutDimension {
        return self.widthAnchor
    }
    var height: NSLayoutDimension {
        return self.heightAnchor
    }
}

public
func +<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, rhs)
}
public
func -<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, -rhs)
}

// MARK: -  have offset
public
func ==<A: LayoutAnchor>(lhs: LayoutAnchorProperty<A>, rhs: (A, CGFloat)) {
    lhs.equal(to: rhs.0, offsetBy: rhs.1)
}
public
func >=<A: LayoutAnchor>(lhs: LayoutAnchorProperty<A>, rhs: (A, CGFloat)) {
    lhs.greaterThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}
public
func <=<A: LayoutAnchor>(lhs: LayoutAnchorProperty<A>, rhs: (A, CGFloat)) {
    lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

//MARK: -  without offset
public
func ==<A: LayoutAnchor>(lhs: LayoutAnchorProperty<A>, rhs: A) {
    lhs.equal(to: rhs)
}
public
func >=<A: LayoutAnchor>(lhs: LayoutAnchorProperty<A>, rhs: A) {
    lhs.greaterThanOrEqual(to: rhs)
}
public
func <=<A: LayoutAnchor>(lhs: LayoutAnchorProperty<A>, rhs: A) {
    lhs.lessThanOrEqual(to: rhs)
}

public
func *<B: LayoutDimension>(lhs: B, rhs: CGFloat) -> (B, CGFloat) {
    return (lhs, rhs)
}
public
func /<B: LayoutDimension>(lhs: B, rhs: CGFloat) -> (B, CGFloat) {
    return (lhs, 1/rhs)
}
public
func +<B: LayoutDimension>(lhs: B, rhs: CGFloat) -> (B, CGFloat) {
    return (lhs, rhs)
}
public
func -<B: LayoutDimension>(lhs: B, rhs: CGFloat) -> (B, CGFloat) {
    return (lhs, -rhs)
}

public
func +<B: LayoutDimension>(lhs: (B, CGFloat), rhs: CGFloat) -> ((B, CGFloat), CGFloat) {
    return ((lhs.0, lhs.1), rhs)
}
public
func -<B: LayoutDimension>(lhs: (B, CGFloat), rhs: CGFloat) -> ((B, CGFloat), CGFloat) {
    return ((lhs.0, lhs.1), -rhs)
}

// MARK: - only otherAnchor
public
func ==<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: B) {
    lhs.equal(to: rhs)
}
public
func >=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: B) {
    lhs.greaterThanOrEqual(to: rhs)
}
public
func <=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: B) {
    lhs.lessThanOrEqual(to: rhs)
}

// MARK: - otherAnchor * multiplier
public
func ==<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: (B, CGFloat)) {
    lhs.equal(to: rhs.0, multiplier: rhs.1, constant: 0)
}
public
func >=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: (B, CGFloat)) {
    lhs.greaterThanOrEqual(to: rhs.0, multiplier: rhs.1, constant: 0)
}
public
func <=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: (B, CGFloat)) {
    lhs.lessThanOrEqual(to: rhs.0, multiplier: rhs.1, constant: 0)
}

// MARK: - otherAnchor * multiplier + constant
public
func ==<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: ((B, CGFloat), CGFloat)) {
    lhs.equal(to: rhs.0.0, multiplier: rhs.0.1, constant: rhs.1)
}
public
func >=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: ((B, CGFloat), CGFloat)) {
    lhs.greaterThanOrEqual(to: rhs.0.0, multiplier: rhs.0.1, constant: rhs.1)
}
public
func <=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: ((B, CGFloat), CGFloat)) {
    lhs.lessThanOrEqual(to: rhs.0.0, multiplier: rhs.0.1, constant: rhs.1)
}

// MARK: - otherDimension * multiplier + constant
public
func ==<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>,
                            rhs: LayoutDimensionProperty<B>) {
    lhs.equal(to: rhs.anchor)
}
public
func >=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>,
                            rhs: LayoutDimensionProperty<B>) {
    lhs.greaterThanOrEqual(to: rhs.anchor)
}
public
func <=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>,
                            rhs: LayoutDimensionProperty<B>) {
    lhs.lessThanOrEqual(to: rhs.anchor)
}

// MARK: - only constant
public
func ==<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: CGFloat) {
    lhs.equal(to: rhs)
}
public
func >=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: CGFloat) {
    lhs.greaterThanOrEqual(to: rhs)
}
public
func <=<B: LayoutDimension>(lhs: LayoutDimensionProperty<B>, rhs: CGFloat) {
    lhs.lessThanOrEqual(to: rhs)
}
//MARK: -  UIColor -> Hex String
extension UIColor {
     
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
//MARK: - 手势
typealias viewAction = (UIGestureRecognizer)->()

//添加手势枚举
extension UIView {
    enum GestureENUM {
        case tap //点击
        case long //长按
        case pan //拖拽
        case roation //旋转
        case swipe //轻扫
        case pinch //捏合
    }
    
    private struct AssociatedKeys {
        static var actionKey = "gestureKey"
    }
    
    @objc dynamic var action:viewAction? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            if let action = objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? viewAction {
                return action
            }
            return nil
        }
    }
    
    @objc func viewTapAction(gesture: UIGestureRecognizer) {
        if action != nil {
            action!(gesture)
        }
    }
    /// 添加手势
    func addGesture( _ gesture : GestureENUM , response:@escaping viewAction) {
        
        self.isUserInteractionEnabled = true
        switch gesture {
        case .tap: //点击
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapAction(gesture:)))
            tapGesture.numberOfTouchesRequired = 1
            tapGesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(tapGesture)
            self.action = response
        case .long: //长按
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(viewTapAction(gesture:)))
            self.addGestureRecognizer(longPress)
            self.action = response
        case .pan: //拖拽
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewTapAction(gesture:)))
            self.addGestureRecognizer(panGesture)
            self.action = response
        case .roation: // 旋转
            let roation = UIRotationGestureRecognizer(target: self, action: #selector(viewTapAction(gesture:)))
            self.addGestureRecognizer(roation)
            self.action = response
        case .swipe: //轻扫
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(viewTapAction(gesture:)))
            self.addGestureRecognizer(swipe)
            self.action = response
        case .pinch: //捏合
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(viewTapAction(gesture:)))
            self.addGestureRecognizer(pinch)
            self.action = response
        }
    }
}
/// 代码延迟运行
///
/// - Parameters:
///   - delayTime: 延时时间。比如：.seconds(5)、.milliseconds(500)
///   - qosClass: 要使用的全局QOS类（默认为 nil，表示主线程）
///   - closure: 延迟运行的代码
public func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
                  _ closure: @escaping () -> Void) {
    let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
    dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)
}
extension UIView
{

    /**
    Starts rotating the view around Z axis.

    @param duration Duration of one full 360 degrees rotation. One second is default.
    @param repeatCount How many times the spin should be done. If not provided, the view will spin forever.
    @param clockwise Direction of the rotation. Default is clockwise (true).
     */
    func startZRotation(duration duration: CFTimeInterval = 0.3, repeatCount: Float = Float.infinity, clockwise: Bool = true)
    {
        if self.layer.animation(forKey: "transform.rotation.z") != nil {
            return
        }
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let direction = clockwise ? 1.0 : -1.0
        animation.toValue = NSNumber(value: M_PI * 2 * direction)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeatCount
        self.layer.add(animation, forKey:"transform.rotation.z")
    }


    /// Stop rotating the view around Z axis.
    func stopZRotation()
    {
        self.layer.removeAnimation(forKey: "transform.rotation.z")
    }

}
