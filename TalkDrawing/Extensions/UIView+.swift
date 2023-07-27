
import UIKit

// MARK: - LayoutProxy
public class LayoutProxy {
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
