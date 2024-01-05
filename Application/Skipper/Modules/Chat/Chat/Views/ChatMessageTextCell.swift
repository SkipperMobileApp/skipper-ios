//
//  ChatMessageTextCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 01.01.2024.
//

import Reusable
import UIKit

class ChatMessageTextCell: SetupableTableViewCell, Reusable {
    // MARK: - UI Controls

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.secondary100()
        label.font = R.typo.caption
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()

    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.secondary100()
        label.font = R.typo.body
        label.numberOfLines = 0
        return label
    }()

    private var bubbleLeftConstraint: NSLayoutConstraint!
    private var bubbleRightConstraint: NSLayoutConstraint!

    // MARK: - UI Methods

    override func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(timeLabel)

        let bubbleConstraints = bubbleView.applyConstraints(
            .top(to: contentView, attribute: .top, constant: 4),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .bottom(to: contentView, attribute: .bottom, constant: -4),
            .width(
                to: contentView,
                attribute: .width,
                multiplier: 0.75,
                equality: .lessThanOrEqual
            ),
            .width(constant: 80, equality: .greaterThanOrEqual)
        )

        bubbleLeftConstraint = bubbleConstraints[1]
        bubbleRightConstraint = bubbleConstraints[2]

        messageLabel.applyConstraints(
            .top(to: bubbleView, attribute: .top, constant: 8),
            .leading(to: bubbleView, attribute: .leading, constant: 8),
            .trailing(to: bubbleView, attribute: .trailing, constant: -8)
        )

        timeLabel.applyConstraints(
            .top(to: messageLabel, attribute: .bottom, constant: 8),
            .trailing(to: bubbleView, attribute: .trailing, constant: -8),
            .bottom(to: bubbleView, attribute: .bottom, constant: -8)
        )

        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    func configure(with model: ViewModel) {
        messageLabel.text = model.text
        timeLabel.text = model.time

        messageLabel.textColor =
            model.isBelongToCurrentUser ? R.color.secondary100() : R.color.primary87()
        timeLabel.textColor =
            model.isBelongToCurrentUser ? R.color.secondary100() : R.color.primary87()

        bubbleLeftConstraint.isActive = !model.isBelongToCurrentUser
        bubbleRightConstraint.isActive = model.isBelongToCurrentUser

        bubbleView.backgroundColor =
            model.isBelongToCurrentUser ? R.color.brandPrimary() : R.color.gray20()

        bubbleView.layer.maskedCorners = model.isBelongToCurrentUser ? [
            .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner
        ] : [
            .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner
        ]
    }
}

// MARK: - ViewModel

extension ChatMessageTextCell {
    struct ViewModel: Hashable {
        let id: String
        let text: String
        let time: String
        let isBelongToCurrentUser: Bool
    }
}
