//
//  LabeledImageView.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.01.2023.
//

import Foundation
import UIKit

class LabeledImageView: SetupableView {
    // MARK: - UI Controls

    private lazy var label: UILabel = .init()

    private lazy var imageView: UIImageView = .init()

    // MARK: - Properties

    var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }

    var textColor: UIColor {
        get { label.textColor }
        set { label.textColor = newValue }
    }

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    var imageTintColor: UIColor? {
        get { imageView.tintColor }
        set { imageView.tintColor = newValue }
    }

    override func setup() {
        super.setup()

        addSubview(label)
        addSubview(imageView)

        label.applyConstraints(
            .trailing(to: imageView, attribute: .leading, constant: -3),
            .leading(to: self, attribute: .leading),
            .centerY(to: imageView, attribute: .centerY)
        )

        imageView.applyConstraints(
            .top(to: self, attribute: .top),
            .trailing(to: self, attribute: .trailing),
            .bottom(to: self, attribute: .bottom)
        )
    }
}
