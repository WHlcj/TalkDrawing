
import UIKit

public extension UILayoutGuide {
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
