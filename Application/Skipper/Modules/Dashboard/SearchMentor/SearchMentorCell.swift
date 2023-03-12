//
//  SearchMentorCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2023.
//

import Foundation
import Reusable
import UIKit

class SearchMentorCell: SetupableTableViewCell, Reusable {
    // MARK: - Definitions

    private enum Constants {
        static let cloudViewLayoutAttributes = CloudView.Layout.Attributes(
            insets: .zero,
            rowSpace: 8,
            itemSpace: 8,
            itemHeight: 30,
            alignment: .left
        )
        static let contentInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let edgeInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    }

    // MARK: - UI Controls

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.themePrimary()
        view.layer.cornerRadius = 12
        view.addShadow()
        return view
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = R.color.primary24()
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1
        return label
    }()

    private lazy var majorLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.body
        label.numberOfLines = 2
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.body
        label.numberOfLines = 0
        return label
    }()

    private lazy var ratingView: LabeledImageView = {
        let view = LabeledImageView()
        view.font = R.typo.body1
        view.textColor = R.color.primary87()!
        view.imageTintColor = R.color.brandPrimary()
        view.image = R.icon.star
        return view
    }()

    private lazy var subcategoriesCloudView: CloudView = .init()

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(majorLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(ratingView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(subcategoriesCloudView)

        containerView.applyConstraints(.fitWithInsets(in: contentView, insets: Constants.edgeInsets))

        avatarImageView.applyConstraints(
            .leading(to: containerView, attribute: .leading, constant: Constants.contentInsets.left),
            .top(to: containerView, attribute: .top, constant: Constants.contentInsets.top),
            .height(constant: 64),
            .width(constant: 64)
        )

        nameLabel.applyConstraints(
            .leading(to: avatarImageView, attribute: .trailing, constant: 8),
            .top(to: containerView, attribute: .top, constant: Constants.contentInsets.top),
            .trailing(to: ratingView, attribute: .leading, constant: -8, equality: .lessThanOrEqual)
        )

        ratingView.applyConstraints(
            .centerY(to: nameLabel, attribute: .centerY),
            .trailing(to: containerView, attribute: .trailing, constant: -Constants.contentInsets.right)
        )

        majorLabel.applyConstraints(
            .top(to: nameLabel, attribute: .bottom, constant: 4),
            .leading(to: avatarImageView, attribute: .trailing, constant: 8),
            .trailing(to: containerView, attribute: .trailing, constant: -Constants.contentInsets.right)
        )

        descriptionLabel.applyConstraints(
            .top(to: avatarImageView, attribute: .bottom, constant: 8),
            .leading(to: containerView, attribute: .leading, constant: Constants.contentInsets.left),
            .trailing(to: containerView, attribute: .trailing, constant: -Constants.contentInsets.right)
        )

        subcategoriesCloudView.applyConstraints(
            .top(to: descriptionLabel, attribute: .bottom, constant: 8),
            .leading(to: containerView, attribute: .leading, constant: Constants.contentInsets.left),
            .trailing(to: containerView, attribute: .trailing, constant: -Constants.contentInsets.right),
            .bottom(to: containerView, attribute: .bottom, constant: -Constants.contentInsets.bottom)
        )
    }

    func configureWith(
        name: String,
        major: String,
        rating: Double,
        imageUrl: String?,
        description: String,
        subcategories: [String],
        layoutWidth: CGFloat
    ) {
        nameLabel.text = name
        majorLabel.text = major
        ratingView.text = String(format: "%.1lf", rating)
        avatarImageView.kf.setImage(with: URL(string: imageUrl ?? ""), placeholder: nil)
        descriptionLabel.text = description

        let items = subcategories.map {
            let item = TextCloudItem()
            item.text = $0
            item.backgroundColor = R.color.brandPrimary()!
            item.textColor = R.color.secondary100()!
            item.font = R.typo.body
            return item
        }

        let edgeInsets = Constants.edgeInsets
        let contentInsets = Constants.contentInsets
        let availableWidth = layoutWidth - edgeInsets.left - contentInsets.left - edgeInsets.right - contentInsets.right
        let layout = CloudView.calculateLayout(
            for: items,
            attributes: Constants.cloudViewLayoutAttributes,
            width: availableWidth
        )
        subcategoriesCloudView.updateWith(items, layout: layout)
    }

    func performBlink() {
        containerView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn, .autoreverse]) { [weak self] in
            self?.containerView.backgroundColor = R.color.brandPrimary()?.withAlphaComponent(0.3)
        } completion: { [weak self] finished in
            if finished {
                self?.containerView.backgroundColor = R.color.themePrimary()
            }
        }
    }
}
