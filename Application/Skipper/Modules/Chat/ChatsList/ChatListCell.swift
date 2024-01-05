//
//  ChatListCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.12.2023.
//

import Reusable
import UIKit

class ChatListCell: SetupableTableViewCell, Reusable {
    // MARK: - UI Controls

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.body
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.body
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()

    // MARK: - UI Methods

    override func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateTimeLabel)

        avatarImageView.applyConstraints(
            .top(to: contentView, attribute: .top, constant: 8),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .bottom(to: contentView, attribute: .bottom, constant: -8),
            .width(constant: 48),
            .height(constant: 48)
        )

        nameLabel.applyConstraints(
            .top(to: avatarImageView, attribute: .top),
            .leading(to: avatarImageView, attribute: .trailing, constant: 8)
        )

        messageLabel.applyConstraints(
            .top(to: nameLabel, attribute: .bottom, constant: 8),
            .leading(to: avatarImageView, attribute: .trailing, constant: 8),
            .trailing(to: contentView, attribute: .trailing, constant: -16)
        )

        dateTimeLabel.applyConstraints(
            .top(to: avatarImageView, attribute: .top),
            .leading(to: nameLabel, attribute: .trailing, constant: 4),
            .trailing(to: contentView, attribute: .trailing, constant: -16)
        )

        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        dateTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateTimeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    func configure(with model: ViewModel) {
        nameLabel.text = model.name
        messageLabel.text = model.message
        dateTimeLabel.text = model.date

        avatarImageView.kf.setImage(with: URL(string: model.avatarUrl ?? ""))
    }
}

extension ChatListCell {
    struct ViewModel: Hashable {
        let id: String
        let opponentId: String
        let avatarUrl: String?
        let name: String
        let message: String
        let date: String
    }
}
