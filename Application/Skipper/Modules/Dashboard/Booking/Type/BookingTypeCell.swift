//
//  BookingTypeCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation
import Reusable
import UIKit

class BookingTypeCell: SetupableTableViewCell, Reusable {
    // MARK: - UI Controls

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.themePrimary()
        view.layer.cornerRadius = 12
        view.addShadow()
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.body
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            updateStyle()
        }
    }

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)

        containerView.applyConstraints(
            .fitWithInsets(in: contentView, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        )

        titleLabel.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

        descriptionLabel.applyConstraints(
            .top(to: titleLabel, attribute: .bottom, constant: 8),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .bottom(to: containerView, attribute: .bottom, constant: -16)
        )

        updateStyle()
    }

    func configureWith(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }

    private func updateStyle() {
        containerView.backgroundColor =
            isSelected ? R.color.brandPrimary()?.withAlphaComponent(0.3) : R.color.themePrimary()
    }
}
