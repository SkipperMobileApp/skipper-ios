//
//  BookingContactCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation
import Reusable
import UIKit

class BookingContactCell: SetupableTableViewCell, Reusable {
    // MARK: - UI Controls

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.themePrimary()
        view.layer.cornerRadius = 12
        view.addShadow()
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = CircleImageView()
        imageView.tintColor = R.color.primary24()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            updateStyle()
        }
    }

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(logoImageView)

        containerView.applyConstraints(
            .fitWithInsets(in: contentView, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        )

        logoImageView.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 8),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .bottom(to: containerView, attribute: .bottom, constant: -8),
            .height(constant: 64),
            .width(constant: 64)
        )

        titleLabel.applyConstraints(
            .centerY(to: logoImageView, attribute: .centerY),
            .leading(to: logoImageView, attribute: .trailing, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )
    }

    func configureWith(title: String, image: UIImage?) {
        titleLabel.text = title
        logoImageView.image = image
    }

    private func updateStyle() {
        containerView.backgroundColor =
            isSelected ? R.color.brandPrimary()?.withAlphaComponent(0.3) : R.color.themePrimary()
    }
}
