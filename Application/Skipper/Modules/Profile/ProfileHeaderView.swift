//
//  ProfileHeaderView.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.01.2023.
//

import Foundation
import Kingfisher
import UIKit

class ProfileHeaderView: SetupableView {
    // MARK: - UI Controls

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = R.color.primary24()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var editAvatarButton: UIButton = {
        let button = UIButton()
        button.setImage(R.icon.cameraCircle, for: .normal)
        button.tintColor = R.color.brandPrimary()
        button.imageView?.backgroundColor = .white
        button.imageView?.layer.cornerRadius = 14

        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)

        button.addTarget(self, action: #selector(editAvatarAction), for: .touchUpInside)
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header2
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.body
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Output

    var didTapEditAvatar: (() -> Void)?

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        addSubview(avatarImageView)
        addSubview(editAvatarButton)
        addSubview(nameLabel)
        addSubview(emailLabel)

        avatarImageView.applyConstraints(
            .centerX(to: self, attribute: .centerX),
            .top(to: self, attribute: .top, constant: 16),
            .height(constant: 100),
            .width(constant: 100)
        )

        editAvatarButton.applyConstraints(
            .centerX(to: avatarImageView, attribute: .trailing),
            .centerY(to: avatarImageView, attribute: .bottom),
            .height(constant: 44),
            .width(constant: 44)
        )

        nameLabel.applyConstraints(
            .top(to: editAvatarButton, attribute: .bottom, constant: 12),
            .leading(to: self, attribute: .leading, constant: 16),
            .trailing(to: self, attribute: .trailing, constant: -16)
        )

        emailLabel.applyConstraints(
            .top(to: nameLabel, attribute: .bottom, constant: 8),
            .leading(to: self, attribute: .leading, constant: 16),
            .trailing(to: self, attribute: .trailing, constant: -16),
            .bottom(to: self, attribute: .bottom, constant: -16)
        )
    }

    func configure(with model: ViewModel) {
        avatarImageView.kf.setImage(
            with: URL(string: model.avatarUrl ?? ""),
            placeholder: nil
        )

        nameLabel.text = model.name
        emailLabel.text = model.email
    }

    // MARK: - UI Callbacks

    @objc private func editAvatarAction() {
        didTapEditAvatar?()
    }
}

// MARK: - ViewModel

extension ProfileHeaderView {
    struct ViewModel {
        let avatarUrl: String?
        let name: String
        let email: String
    }
}
