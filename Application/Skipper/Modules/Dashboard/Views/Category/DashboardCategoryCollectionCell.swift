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
        imageView.contentMode = .scaleToFill
        imageView.tintColor = R.color.secondary100()
        return imageView
    }()

    private lazy var imageContainer: GradientView = {
        let view = GradientView()
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = R.color.primary87()
        label.font = R.typo.caption
        label.textAlignment = .center
        return label
    }()

//    private lazy var gradientLayer: CALayer = {
//        let layer = CAGradientLayer()
//        layer.colors = [
//            R.color.gradientCategoryFirst(),
//            R.color.gradientCategorySecond()
//        ].compactMap { $0?.cgColor }
//        layer.startPoint = .init(x: 0, y: 1)
//        layer.endPoint = .init(x: 1, y: 0)
//        layer.cornerRadius = 8
//        return layer
//    }()

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        contentView.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageContainer.applyConstraints(
            .top(to: contentView, attribute: .top),
            .leading(to: contentView, attribute: .leading),
            .trailing(to: contentView, attribute: .trailing),
            .height(to: imageContainer, attribute: .width)
        )

        imageView.applyConstraints(
            .fit(in: imageContainer, inset: 16)
        )

        titleLabel.applyConstraints(
            .top(to: imageContainer, attribute: .bottom, constant: Constants.innerInset),
            .leading(to: contentView, attribute: .leading),
            .trailing(to: contentView, attribute: .trailing),
            .bottom(to: contentView, attribute: .bottom, equality: .lessThanOrEqual)
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - UI Methods

    func configureWith(image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
}
