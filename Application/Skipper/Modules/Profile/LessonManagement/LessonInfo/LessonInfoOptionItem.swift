//
//  LessonInfoOptionItem.swift
//  Skipper
//
//  Created by Denis Kovalev on 21.05.2023.
//

import Foundation
import UIKit

class LessonInfoOptionItem: SetupableControl {
    // MARK: - UI Controls

    private lazy var checkboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.tintColor = R.color.brandPrimary()
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.body1
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            updateState()
        }
    }

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        addSubview(checkboxImageView)
        addSubview(titleLabel)

        checkboxImageView.applyConstraints(
            .leading(to: self, attribute: .leading),
            .top(to: self, attribute: .top, constant: 5, equality: .greaterThanOrEqual),
            .bottom(to: self, attribute: .bottom, constant: -5, equality: .lessThanOrEqual),
            .centerY(to: self, attribute: .centerY),
            .width(constant: 36),
            .height(constant: 36)
        )

        titleLabel.applyConstraints(
            .leading(to: checkboxImageView, attribute: .trailing, constant: 16),
            .centerY(to: checkboxImageView, attribute: .centerY),
            .top(to: self, attribute: .top, constant: 5, equality: .greaterThanOrEqual),
            .bottom(to: self, attribute: .bottom, constant: -5, equality: .lessThanOrEqual),
            .trailing(to: self, attribute: .trailing)
        )

        updateState()
    }

    func configure(with title: String, isChecked: Bool) {
        titleLabel.text = title
        isSelected = isChecked
    }

    private func updateState() {
        checkboxImageView.image = isSelected ? R.icon.checkboxOn : R.icon.checkboxOff
    }
}
