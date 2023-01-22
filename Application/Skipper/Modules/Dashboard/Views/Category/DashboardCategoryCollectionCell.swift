//
//  DashboardCategoryCollectionCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 03.01.2023.
//

import Foundation
import Reusable
import UIKit

class DashboardCategoryCollectionCell: SetupableCollectionViewCell, Reusable {
    // MARK: - Definitions

    private enum Constants {
        static let innerInset: CGFloat = 5
    }

    // MARK: - UI Controls

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = R.color.gray50()
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = R.color.primary87()
        label.font = R.typo.caption
        label.textAlignment = .center
        return label
    }()

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageView.applyConstraints(
            .top(to: contentView, attribute: .top),
            .leading(to: contentView, attribute: .leading),
            .trailing(to: contentView, attribute: .trailing),
            .height(to: imageView, attribute: .width)
        )

        titleLabel.applyConstraints(
            .top(to: imageView, attribute: .bottom, constant: Constants.innerInset),
            .leading(to: contentView, attribute: .leading),
            .trailing(to: contentView, attribute: .trailing),
            .bottom(to: contentView, attribute: .bottom, equality: .lessThanOrEqual)
        )
    }

    // MARK: - UI Methods

    func configureWith(imageUrl: String?, title: String) {
        imageView.kf.setImage(with: URL(string: imageUrl ?? ""), placeholder: nil)
        titleLabel.text = title
    }
}
