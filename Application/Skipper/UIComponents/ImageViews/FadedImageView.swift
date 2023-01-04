//
//  FadedImageView.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.01.2023.
//

import Foundation
import UIKit

class FadedImageView: SetupableImageView {
    // MARK: - UI Controls

    private lazy var gradientLayer: CALayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        layer.type = .axial
        layer.startPoint = .init(x: 0.5, y: 0)
        layer.endPoint = .init(x: 0.5, y: 0.8)
        layer.locations = [0.15, 1.0]
        return layer
    }()

    // MARK: - UI Lifecycle
    
    override func setup() {
        super.setup()

        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }
}
