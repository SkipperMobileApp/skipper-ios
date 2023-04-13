//
//  LessonDetailsInfoView.swift
//  Skipper
//
//  Created by Denis Kovalev on 11.04.2023.
//

import Foundation
import UIKit

/// Lesson info label
/// Lesson description
/// Time
/// Contact

class LessonDetailsInfoView: SetupableView {
    // MARK: - UI Controls

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.text = Strings.myLessonsLessonInfoLabel()
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = R.color.primary87()
        label.font = R.typo.body
        return label
    }()

    private lazy var timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = R.color.brandPrimary()
        imageView.contentMode = .scaleToFill
        imageView.image = R.icon.clockCircle
        return imageView
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.body
        label.numberOfLines = 0
        return label
    }()

    private lazy var contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = R.color.brandPrimary()
        imageView.contentMode = .scaleToFill
        imageView.image = R.icon.chatCircle
        return imageView
    }()

    private lazy var contactLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.body
        label.numberOfLines = 0
        return label
    }()

    override func setup() {
        super.setup()

        addSubview(infoLabel)
        addSubview(descriptionLabel)
        addSubview(timeImageView)
        addSubview(timeLabel)
        addSubview(contactImageView)
        addSubview(contactLabel)

        infoLabel.applyConstraints(
            .top(to: self, attribute: .top, constant: 16),
            .leading(to: self, attribute: .leading, constant: 16),
            .trailing(to: self, attribute: .trailing, constant: -16)
        )

        descriptionLabel.applyConstraints(
            .top(to: infoLabel, attribute: .bottom, constant: 8),
            .leading(to: self, attribute: .leading, constant: 16),
            .trailing(to: self, attribute: .trailing, constant: -16)
        )

        timeImageView.applyConstraints(
            .top(to: descriptionLabel, attribute: .bottom, constant: 16),
            .leading(to: self, attribute: .leading, constant: 16),
            .width(constant: 32),
            .height(constant: 32)
        )

        timeLabel.applyConstraints(
            .centerY(to: timeImageView, attribute: .centerY),
            .leading(to: timeImageView, attribute: .trailing, constant: 8),
            .trailing(to: self, attribute: .trailing, constant: -16)
        )

        contactImageView.applyConstraints(
            .top(to: timeImageView, attribute: .bottom, constant: 16),
            .leading(to: self, attribute: .leading, constant: 16),
            .width(constant: 32),
            .height(constant: 32)
        )

        contactLabel.applyConstraints(
            .centerY(to: contactImageView, attribute: .centerY),
            .leading(to: contactImageView, attribute: .trailing, constant: 8),
            .trailing(to: self, attribute: .trailing, constant: -16),
            .bottom(to: self, attribute: .bottom, constant: -16)
        )
    }

    // MARK: - UI Methods

    func configureWith(model: ViewModel) {
        descriptionLabel.text = model.description
        contactLabel.text = model.contact
        timeLabel.text = model.time
    }
}

// MARK: - ViewModel

extension LessonDetailsInfoView {
    struct ViewModel {
        let description: String
        let contact: String
        let time: String
    }
}
