//
//  MentorProfileClassItem.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Foundation
import UIKit

class MentorProfileClassItem: SetupableControl {
    // MARK: - UI Controls

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.subheader
        label.textColor = R.color.primary87()
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.body
        label.textColor = R.color.primary54()
        label.numberOfLines = 0
        return label
    }()

    private lazy var disclosureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.icon.disclosure
        imageView.tintColor = R.color.primary24()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override func setup() {
        super.setup()

        backgroundColor = .clear
        layer.cornerRadius = 8

        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(disclosureImageView)

        titleLabel.applyConstraints(
            .leading(to: self, attribute: .leading),
            .top(to: self, attribute: .top, constant: 8),
            .trailing(to: disclosureImageView, attribute: .leading, constant: -8)
        )

        descriptionLabel.applyConstraints(
            .leading(to: self, attribute: .leading),
            .top(to: titleLabel, attribute: .bottom, constant: 8),
            .trailing(to: disclosureImageView, attribute: .leading, constant: -8),
            .bottom(to: self, attribute: .bottom, constant: -8)
        )

        disclosureImageView.applyConstraints(
            .height(constant: 24),
            .width(constant: 12),
            .centerY(to: self, attribute: .centerY),
            .trailing(to: self, attribute: .trailing, constant: -8)
        )
    }

    func configureWith(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }

    func performBlink() {
        layer.removeAllAnimations()
        UIView
            .animate(
                withDuration: 0.15,
                delay: 0,
                options: [.curveEaseIn, .autoreverse]
            ) { [weak self] in
                self?.backgroundColor = R.color.brandPrimary()?.withAlphaComponent(0.3)
            } completion: { [weak self] finished in
                if finished {
                    self?.backgroundColor = .clear
                }
            }
    }
}
