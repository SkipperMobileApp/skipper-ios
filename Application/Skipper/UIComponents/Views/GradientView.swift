//
//  GradientView.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.01.2023.
//

import UIKit

class GradientView: SetupableView {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    override func layoutSubviews() {
        guard let layer = layer as? CAGradientLayer else { return }

        layer.colors = [
            R.color.gradientCategoryFirst(),
            R.color.gradientCategorySecond()
        ].compactMap { $0?.cgColor }
        layer.startPoint = .init(x: 0, y: 1)
        layer.endPoint = .init(x: 1, y: 0)
        layer.cornerRadius = 8
    }
}
