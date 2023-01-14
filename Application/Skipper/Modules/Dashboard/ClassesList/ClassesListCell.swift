//
//  ClassesListCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation
import Reusable
import UIKit

class ClassesListCell: SetupableTableViewCell, Reusable {
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
        accessoryType = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(disclosureImageView)

        titleLabel.applyConstraints(
            .leading(to: contentView, attribute: .leading, constant: 16),
            .top(to: contentView, attribute: .top, constant: 8),
            .trailing(to: disclosureImageView, attribute: .leading, constant: -8)
        )

        descriptionLabel.applyConstraints(
            .leading(to: contentView, attribute: .leading, constant: 16),
            .top(to: titleLabel, attribute: .bottom, constant: 8),
            .trailing(to: disclosureImageView, attribute: .leading, constant: -8),
            .bottom(to: contentView, attribute: .bottom, constant: -8)
        )

        disclosureImageView.applyConstraints(
            .height(constant: 24),
            .width(constant: 12),
            .centerY(to: contentView, attribute: .centerY),
            .trailing(to: contentView, attribute: .trailing, constant: -16)
        )
    }

    func configureWith(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
