//
//  UserView.swift
//  Skipper
//
//  Created by Denis Kovalev on 03.01.2024.
//

import Foundation
import UIKit

class UserView: SetupableView {
    // MARK: - UI Controls

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.backgroundColor = R.color.gray30()
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.header
        label.textColor = R.color.primary87()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    // MARK: - Lifecycle

    override func setup() {
        super.setup()

        backgroundColor = .clear

        addSubview(avatarImageView)
        addSubview(nameLabel)

        avatarImageView.applyConstraints(
            .top(to: self, attribute: .top, constant: 2, equality: .greaterThanOrEqual),
            .leading(to: self, attribute: .leading),
            .bottom(to: self, attribute: .bottom, constant: -2, equality: .lessThanOrEqual),
            .centerY(to: self, attribute: .centerY),
            .width(constant: 32),
            .height(constant: 32)
        )

        nameLabel.applyConstraints(
            .centerY(to: avatarImageView, attribute: .centerY),
            .leading(to: avatarImageView, attribute: .trailing, constant: 8),
            .trailing(to: self, attribute: .trailing)
        )
    }

    func configure(with model: ViewModel) {
        nameLabel.text = model.name

        avatarImageView.kf.setImage(with: URL(string: model.avatarURL ?? ""))
    }
}

extension UserView {
    struct ViewModel {
        let name: String
        let avatarURL: String?
    }
}
