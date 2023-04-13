//
//  LessonDetailsHeaderView.swift
//  Skipper
//
//  Created by Denis Kovalev on 10.04.2023.
//

import Foundation
import UIKit

/// Title
/// Lesson Type
/// Mentor info with avatar

class LessonDetailsHeaderView: SetupableView {
    // MARK: - UI Controls

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = R.color.primary87()
        label.font = R.typo.header4
        return label
    }()

    private lazy var lessonTypeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        return label
    }()

    private lazy var mentorHeaderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = R.color.primary87()
        label.font = R.typo.caption
        label.text = Strings.myLessonsLessonInfoMentor()
        return label
    }()

    private lazy var mentorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = R.color.primary87()
        label.font = R.typo.body
        return label
    }()

    private lazy var mentorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = R.color.gray30()
        return imageView
    }()

    override func setup() {
        super.setup()

        addSubview(titleLabel)
        addSubview(lessonTypeLabel)
        addSubview(mentorHeaderLabel)
        addSubview(mentorNameLabel)
        addSubview(mentorImageView)

        titleLabel.applyConstraints(
            .top(to: self, attribute: .top, constant: 16),
            .leading(to: self, attribute: .leading, constant: 16),
            .trailing(to: self, attribute: .trailing, constant: -16)
        )

        lessonTypeLabel.applyConstraints(
            .top(to: titleLabel, attribute: .bottom, constant: 8),
            .leading(to: self, attribute: .leading, constant: 16),
            .trailing(to: self, attribute: .trailing, constant: -16)
        )

        mentorImageView.applyConstraints(
            .top(to: lessonTypeLabel, attribute: .bottom, constant: 16),
            .leading(to: self, attribute: .leading, constant: 16),
            .width(constant: 60),
            .height(constant: 60),
            .bottom(to: self, attribute: .bottom, constant: -8)
        )

        mentorNameLabel.applyConstraints(
            .leading(to: mentorImageView, attribute: .trailing, constant: 8),
            .trailing(to: self, attribute: .trailing, constant: -16),
            .bottom(to: mentorImageView, attribute: .centerY, constant: -4)
        )

        mentorHeaderLabel.applyConstraints(
            .leading(to: mentorImageView, attribute: .trailing, constant: 8),
            .trailing(to: self, attribute: .trailing, constant: -16),
            .top(to: mentorImageView, attribute: .centerY, constant: 4)
        )
    }

    // MARK: - UI Methods

    func configureWith(model: ViewModel) {
        titleLabel.text = model.title
        lessonTypeLabel.text = model.type
        mentorNameLabel.text = model.mentorName

        mentorImageView.kf.setImage(with: URL(string: model.mentorAvatarUrl ?? ""))
    }
}

extension LessonDetailsHeaderView {
    struct ViewModel {
        let title: String
        let type: String
        let mentorName: String
        let mentorAvatarUrl: String?
    }
}
