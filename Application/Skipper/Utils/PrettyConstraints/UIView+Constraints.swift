//
//  UIView+Constraints.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//  Copyright © 2022 Denis Kovalev. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIView {
    /// Applies constraints to the current view. Returns array of Autolayout constraints in direct order.
    @discardableResult
    func applyConstraints(_ constraints: Constraints...) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var appliedConstraints: [NSLayoutConstraint] = []
        for constraint in constraints {
            var appliedConstraint: NSLayoutConstraint?
            switch constraint {
            case let .top(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.top, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .bottom(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.bottom, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .leading(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.leading, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .trailing(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.trailing, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .left(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.left, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .right(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.right, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .width(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.width, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .height(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.height, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .centerX(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.centerX, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .centerY(view, attribute, constant, multiplier, equality):
                appliedConstraint = setConstraint(.centerY, to: view, attribute: attribute, equality: equality, constant: constant, multiplier: multiplier)
            case let .fit(element, constant):
                let internalConstraints = applyConstraints(.top(to: element, attribute: .top, constant: constant),
                                                           .leading(to: element, attribute: .leading, constant: constant),
                                                           .trailing(to: element, attribute: .trailing, constant: -constant),
                                                           .bottom(to: element, attribute: .bottom, constant: -constant))
                appliedConstraints.append(contentsOf: internalConstraints)
            case let .fitWithInsets(element, insets):
                let internalConstraints = applyConstraints(.top(to: element, attribute: .top, constant: insets.top),
                                                           .leading(to: element, attribute: .leading, constant: insets.left),
                                                           .trailing(to: element, attribute: .trailing, constant: -insets.right),
                                                           .bottom(to: element, attribute: .bottom, constant: -insets.bottom))
                appliedConstraints.append(contentsOf: internalConstraints)
            case let .center(element):
                let internalConstraints = applyConstraints(.centerX(to: element, attribute: .centerX),
                                                           .centerY(to: element, attribute: .centerY))
                appliedConstraints.append(contentsOf: internalConstraints)
            }
            if let appliedConstraint = appliedConstraint {
                appliedConstraints.append(appliedConstraint)
            }
        }
        return appliedConstraints
    }

    /// Fits current view in view's superview with constant `insets`.
    /// `relativeToSafeArea` parameter determines whether insets will be extended with safe area layout guide values or not
    func fitInSuperview(insets: CGFloat = 0, relativeToSafeArea: Bool = false) {
        guard let superview = superview else { return }
        fitInView(superview, insets: insets, relativeToSafeArea: relativeToSafeArea)
    }

    /// Fits current view in `view` with constant `insets`.
    /// `relativeToSafeArea` parameter determines whether insets will be extended with safe area layout guide values or not
    func fitInView(_ view: UIView, insets: CGFloat = 0, relativeToSafeArea: Bool = false) {
        applyConstraints(.fit(in: relativeToSafeArea ? view.safeAreaLayoutGuide : view, inset: insets))
    }

    // MARK: - Private

    /// Sets constraint from current view's `fromAttribute` to `element`'s `attribute` with `equality`, by `constant` and `multiplier`
    /// Returns applied constraint object
    @discardableResult
    private func setConstraint(_ fromAtribute: NSLayoutConstraint.Attribute,
                               to element: Constrainable?,
                               attribute toAttribute: ConstraintAttribute?,
                               equality: NSLayoutConstraint.Relation,
                               constant: CGFloat,
                               multiplier: CGFloat) -> NSLayoutConstraint
    {
        let appliedConstraint = NSLayoutConstraint(item: self,
                                                   attribute: fromAtribute,
                                                   relatedBy: equality,
                                                   toItem: element,
                                                   attribute: element.flatMap { _ in toAttribute?.constraintAttribute } ?? .notAnAttribute,
                                                   multiplier: multiplier,
                                                   constant: constant)
        appliedConstraint.isActive = true
        return appliedConstraint
    }
}

#endif
