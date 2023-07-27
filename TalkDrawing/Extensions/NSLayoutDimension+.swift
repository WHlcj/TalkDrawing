
import UIKit

public protocol LayoutDimension {
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

public struct LayoutDimensionProperty<Anchor: LayoutDimension> {
    let anchor: Anchor
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
