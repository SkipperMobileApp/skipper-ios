//
//  Attributes.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//  Copyright © 2022 Denis Kovalev. All rights reserved.
//

import Foundation
import UIKit

public extension Constraints {
    /// Attributes that might be used for horizontal constraints
    enum XAxisAttribute: ConstraintAttribute {
        case leading
        case trailing
        case left
        case right
        case centerX
        case leadingMargin
        case trailingMargin
        case leftMargin
        case rightMargin
        case centerXWithinMargins

        public var constraintAttribute: NSLayoutConstraint.Attribute {
            switch self {
            case .leading: return .leading
            case .trailing: return .trailing
            case .left: return .left
            case .right: return .right
            case .centerX: return .centerX
            case .leadingMargin: return .leadingMargin
            case .trailingMargin: return .trailingMargin
            case .leftMargin: return .leftMargin
            case .rightMargin: return .rightMargin
            case .centerXWithinMargins: return .centerXWithinMargins
            }
        }
    }

    /// Attributes that might be used for vertical constraints
    enum YAxisAttribute: ConstraintAttribute {
        case top
        case bottom
        case centerY
        case topMargin
        case bottomMargin
        case centerYWithinMargins

        public var constraintAttribute: NSLayoutConstraint.Attribute {
            switch self {
            case .top: return .top
            case .bottom: return .bottom
            case .centerY: return .centerY
            case .topMargin: return .topMargin
            case .bottomMargin: return .bottomMargin
            case .centerYWithinMargins: return .centerYWithinMargins
            }
        }
    }

    /// Attributes that might be used for dimension constraints
    enum DimensionAttribute: ConstraintAttribute {
        case width
        case height

        public var constraintAttribute: NSLayoutConstraint.Attribute {
            switch self {
            case .width: return .width
            case .height: return .height
            }
        }
    }
}
