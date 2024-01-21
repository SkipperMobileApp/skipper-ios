//
//  MentorProfileReviewsView.swift
//  Skipper
//
//  Created by Denis Kovalev on 13.01.2024.
//

import Foundation
import UIKit

class MentorProfileReviewsView: SetupableView {
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

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.body
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 3
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
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(textLabel)
        addSubview(dateLabel)
        addSubview(ratingView)

        avatarImageView.applyConstraints(
            .top(to: self, attribute: .top),
            .leading(to: self, attribute: .leading),
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
            .trailing(to: self, attribute: .trailing)
        )

        textLabel.applyConstraints(
            .top(to: avatarImageView, attribute: .bottom, constant: 12),
            .leading(to: self, attribute: .leading),
            .bottom(to: self, attribute: .bottom),
            .trailing(to: self, attribute: .trailing)
        )

        ratingView.applyConstraints(
            .centerY(to: nameLabel, attribute: .centerY),
            .leading(to: nameLabel, attribute: .trailing, constant: 8),
            .trailing(to: self, attribute: .trailing),
            .height(constant: 16)
        )
    }

    func configure(with model: DisplayData) {
        nameLabel.text = model.name
        dateLabel.text = model.date
        textLabel.text = model.text
        ratingView.configureWith(rating: model.rating)

        avatarImageView.kf.setImage(
            with: URL(string: model.avatarUrl ?? ""),
            placeholder: R.icon.profileCircle
        )
    }
}

extension MentorProfileReviewsView {
    struct DisplayData {
        let avatarUrl: String?
        let name: String
        let date: String
        let text: String
        let rating: Double
    }
}
