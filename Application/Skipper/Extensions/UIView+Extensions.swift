//
//  UIView+Extensions.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2023.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(
        radius: CGFloat = 1.5,
        color: UIColor = .black,
        opacity: Float = 0.4,
        offset: CGSize = .init(width: 0, height: 0.5)
    ) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
    }
}
