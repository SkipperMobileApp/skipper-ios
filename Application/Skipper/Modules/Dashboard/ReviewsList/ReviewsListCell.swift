//
//  ReviewsListCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2024.
//

import Foundation
import Reusable
import UIKit

class ReviewsListCell: SetupableTableViewCell, Reusable {
    // MARK: - UI Controls

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.tintColor = R.color.brandPrimary()
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.body
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.caption
        label.numberOfLines = 1
        return label
    }()

    private let ratingView: RatingView = {
        let view = RatingView()
        return view
    }()

    override func setup() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(ratingView)

        avatarImageView.applyConstraints(
            .top(to: contentView, attribute: .top, constant: 8),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .width(constant: 36),
            .height(constant: 36)
        )

        nameLabel.applyConstraints(
            .top(to: avatarImageView, attribute: .top),
            .leading(to: avatarImageView, attribute: .trailing, constant: 8)
        )

        dateLabel.applyConstraints(
            .top(to: nameLabel, attribute: .bottom, constant: 4),
            .leading(to: avatarImageView, attribute: .trailing, constant: 8),
            .trailing(to: contentView, attribute: .trailing, constant: -16)
        )

        contentLabel.applyConstraints(
            .top(to: avatarImageView, attribute: .bottom, constant: 12),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .bottom(to: contentView, attribute: .bottom, constant: -8),
            .trailing(to: contentView, attribute: .trailing, constant: -16)
        )

        ratingView.applyConstraints(
            .centerY(to: nameLabel, attribute: .centerY),
            .leading(to: nameLabel, attribute: .trailing, constant: 8),
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .height(constant: 16)
        )
    }

    func configure(with model: DisplayData) {
        nameLabel.text = model.name
        dateLabel.text = model.date
        contentLabel.text = model.text
        ratingView.configureWith(rating: model.rating)

        avatarImageView.kf.setImage(
            with: URL(string: model.avatarUrl ?? ""),
            placeholder: R.icon.profileCircle
        )
    }
}

extension ReviewsListCell {
    struct DisplayData {
        let avatarUrl: String?
        let name: String
        let date: String
        let text: String
        let rating: Double
    }
}
