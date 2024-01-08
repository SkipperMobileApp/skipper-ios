//
//  ChatMessageImageCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 03.01.2024.
//

import Kingfisher
import Reusable
import UIKit

class ChatMessageImageCell: SetupableTableViewCell, Reusable {
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

    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = R.color.gray30()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer()
        imageView.addGestureRecognizer(gesture)

        gesture.addTarget(self, action: #selector(imageTapAction))

        return imageView
    }()

    private var bubbleLeftConstraint: NSLayoutConstraint!
    private var bubbleRightConstraint: NSLayoutConstraint!
    private var imageWidthConstraint: NSLayoutConstraint!
    private var imageHeightConstraint: NSLayoutConstraint!

    // MARK: - Output

    var didTapImage: (() -> Void)?

    // MARK: - UI Methods

    override func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(contentImageView)
        bubbleView.addSubview(timeLabel)

        let bubbleConstraints = bubbleView.applyConstraints(
            .top(to: contentView, attribute: .top, constant: 4),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .bottom(to: contentView, attribute: .bottom, constant: -4),
            .width(to: contentView, attribute: .width, multiplier: 0.75, equality: .lessThanOrEqual)
        )

        bubbleLeftConstraint = bubbleConstraints[1]
        bubbleRightConstraint = bubbleConstraints[2]

        let imageConstraints = contentImageView.applyConstraints(
            .top(to: bubbleView, attribute: .top, constant: 8),
            .leading(to: bubbleView, attribute: .leading, constant: 8),
            .trailing(to: bubbleView, attribute: .trailing, constant: -8),
            .width(constant: 200),
            .height(constant: 200)
        )

        imageWidthConstraint = imageConstraints[3]
        imageHeightConstraint = imageConstraints[4]

        timeLabel.applyConstraints(
            .top(to: contentImageView, attribute: .bottom, constant: 8),
            .trailing(to: bubbleView, attribute: .trailing, constant: -8),
            .bottom(to: bubbleView, attribute: .bottom, constant: -8)
        )

        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    func configure(with model: ViewModel) {
        let resizingProcessor = ResizingImageProcessor(
            referenceSize: CGSize(width: 200, height: 200),
            mode: .aspectFill
        )

        contentImageView.kf.setImage(
            with: URL(string: model.url),
            options: [.processor(resizingProcessor)]
        )

        timeLabel.text = model.time
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

    // MARK: - UI Actions

    @objc private func imageTapAction() {
        didTapImage?()
    }
}

// MARK: - ViewModel

extension ChatMessageImageCell {
    struct ViewModel: Hashable {
        let id: String
        let url: String
        let time: String
        let isBelongToCurrentUser: Bool
    }
}
