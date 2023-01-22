//
//  ProfileOptionView.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.01.2023.
//

import Foundation
import UIKit

class ProfileOptionView: SetupableControl {
    // MARK: - UI Controls

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = R.color.brandPrimary()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.body1
        label.numberOfLines = 1
        return label
    }()

    private lazy var disclosureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.icon.disclosure
        imageView.tintColor = R.color.primary24()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(disclosureImageView)

        imageView.applyConstraints(
            .leading(to: self, attribute: .leading, constant: 16),
            .top(to: self, attribute: .top, constant: 8),
            .bottom(to: self, attribute: .bottom, constant: -8),
            .height(constant: 32),
            .width(constant: 32)
        )

        titleLabel.applyConstraints(
            .centerY(to: imageView, attribute: .centerY),
            .leading(to: imageView, attribute: .trailing, constant: 8),
            .trailing(to: disclosureImageView, attribute: .leading, constant: -8)
        )

        disclosureImageView.applyConstraints(
            .trailing(to: self, attribute: .trailing, constant: -16),
            .centerY(to: self, attribute: .centerY),
            .height(constant: 24),
            .width(constant: 12)
        )
    }

    func configureWith(title: String, image: UIImage) {
        titleLabel.text = title
        imageView.image = image
    }

    func performBlink() {
        layer.removeAllAnimations()
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn, .autoreverse]) { [weak self] in
            self?.backgroundColor = R.color.brandPrimary()?.withAlphaComponent(0.3)
        } completion: { [weak self] finished in
            if finished {
                self?.backgroundColor = .clear
            }
        }
    }
}
