//
//  DashboardMentorCollectionCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.01.2023.
//

import Foundation
import Kingfisher
import Reusable
import UIKit

class DashboardMentorCollectionCell: SetupableCollectionViewCell, Reusable {
    // MARK: - UI Controls

    private lazy var imageView: UIImageView = {
        let imageView = FadedImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = R.color.primary54()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.secondary100()
        label.font = R.typo.header2
        label.numberOfLines = 1
        return label
    }()

    private lazy var majorLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.secondary100()
        label.font = R.typo.body
        label.numberOfLines = 2
        return label
    }()

    private lazy var likesView: LabeledImageView = {
        let view = LabeledImageView()
        view.font = R.typo.header2
        view.image = R.icon.like
        view.textColor = R.color.secondary100()!
        view.imageTintColor = R.color.secondary100()!
        return view
    }()

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(majorLabel)
        contentView.addSubview(likesView)

        imageView.applyConstraints(.fit(in: contentView))

        likesView.applyConstraints(
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .bottom(to: contentView, attribute: .bottom, constant: -16)
        )

        majorLabel.applyConstraints(
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: likesView, attribute: .leading, constant: -16, equality: .lessThanOrEqual),
            .bottom(to: contentView, attribute: .bottom, constant: -16)
        )

        nameLabel.applyConstraints(
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: likesView, attribute: .leading, constant: -16, equality: .lessThanOrEqual),
            .bottom(to: majorLabel, attribute: .top, constant: -4)
        )
    }

    func configureWith(name: String, major: String, likesCount: Int, imageUrl: String?) {
        nameLabel.text = name
        majorLabel.text = major
        likesView.text = String(likesCount)
        imageView.kf.setImage(with: URL(string: imageUrl ?? ""), placeholder: nil)
    }
}
