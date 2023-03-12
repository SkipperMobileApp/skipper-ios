//
//  Constraints.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//  Copyright © 2022 Denis Kovalev. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// A protocol for constraint attributes that might be represented into attribute for Autolayout
public protocol ConstraintAttribute {
    /// Autolayout constraint attribute
    var constraintAttribute: NSLayoutConstraint.Attribute { get }
}

/// Constraint anchors to align to other view's anchors
public enum Constraints {
    case top(
        to: Constrainable,
        attribute: YAxisAttribute,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    case bottom(
        to: Constrainable,
        attribute: YAxisAttribute,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    case leading(
        to: Constrainable,
        attribute: XAxisAttribute,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    case trailing(
        to: Constrainable,
        attribute: XAxisAttribute,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    /// Like `.leading`, but ignores layout direction (right-to-left or left-to-right)
    case left(
        to: Constrainable,
        attribute: XAxisAttribute,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    /// Like `.trailing`, but ignores layout direction (right-to-left or left-to-right)
    case right(
        to: Constrainable,
        attribute: XAxisAttribute,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    case width(
        to: Constrainable? = nil,
        attribute: DimensionAttribute? = nil,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    case height(
        to: Constrainable? = nil,
        attribute: DimensionAttribute? = nil,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    case centerX(
        to: Constrainable,
        attribute: XAxisAttribute,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    case centerY(
        to: Constrainable,
        attribute: YAxisAttribute,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1,
        equality: NSLayoutConstraint.Relation = .equal
    )

    /// Fits current view into other Constrainable element (layout guide or view) with constant `inset` from all sides
    case fit(in: Constrainable, inset: CGFloat = 0)

    /// Fits current view into other Constrainable element (layout guide or view) with custom `insets`
    case fitWithInsets(in: Constrainable, insets: UIEdgeInsets = .zero)

    /// Align current view's center anchors (X and Y) to other Constrainable element's center anchors
    case center(in: Constrainable)
}

#endif
