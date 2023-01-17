//
//  BookingTimeCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation
import Reusable
import UIKit

class BookingTimeCell: SetupableTableViewCell, Reusable {
    private enum Constants {
        static let indicatorSize = CGSize(width: 8, height: 8)
        static let deleteButtonSize = CGSize(width: 44, height: 44)
    }

    // MARK: - UI Controls

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.body
        label.numberOfLines = 1
        return label
    }()

    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.brandPrimary()
        view.layer.cornerRadius = Constants.indicatorSize.height / 2
        return view
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(R.icon.trash, for: .normal)
        button.tintColor = R.color.brandError()
        button.contentEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Output

    var didTapDelete: (() -> Void)?

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(indicatorView)
        contentView.addSubview(deleteButton)

        indicatorView.applyConstraints(
            .centerY(to: contentView, attribute: .centerY),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .width(constant: Constants.indicatorSize.width),
            .height(constant: Constants.indicatorSize.height)
        )

        dateLabel.applyConstraints(
            .top(to: contentView, attribute: .top, constant: 16),
            .leading(to: indicatorView, attribute: .trailing, constant: 16),
            .trailing(to: deleteButton, attribute: .leading, constant: -8)
        )

        timeLabel.applyConstraints(
            .top(to: dateLabel, attribute: .bottom, constant: 8),
            .leading(to: indicatorView, attribute: .trailing, constant: 16),
            .trailing(to: deleteButton, attribute: .leading, constant: -8),
            .bottom(to: contentView, attribute: .bottom, constant: -16)
        )

        deleteButton.applyConstraints(
            .centerY(to: contentView, attribute: .centerY),
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .height(constant: Constants.deleteButtonSize.height),
            .width(constant: Constants.deleteButtonSize.width)
        )
    }

    func configureWith(date: String, time: String) {
        dateLabel.text = date
        timeLabel.text = time
    }

    // MARK: - UI Callbacks

    @objc private func deleteAction() {
        didTapDelete?()
    }
}
