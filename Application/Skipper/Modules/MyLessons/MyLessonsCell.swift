//
//  MyLessonsCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 16.01.2023.
//

import Foundation
import Reusable
import UIKit

class MyLessonsCell: SetupableTableViewCell, Reusable {
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
        label.font = R.typo.header2
        label.numberOfLines = 0
        return label
    }()

    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.body1
        label.numberOfLines = 1
        return label
    }()

    private lazy var mentorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.body1
        label.numberOfLines = 0
        return label
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = R.color.primary24()
        return imageView
    }()

    private lazy var mentorLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.caption
        label.numberOfLines = 0
        label.text = "Ментор"
        return label
    }()

    private lazy var descriptionHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1
        label.text = "Описание"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.body
        label.numberOfLines = 0
        return label
    }()

    private lazy var lessonInfoHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1
        label.text = "Информация о занятии"
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

//    private lazy var costImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.tintColor = R.color.brandPrimary()
//        imageView.contentMode = .scaleToFill
//        imageView.image = R.icon.dollarCircle
//        return imageView
//    }()
//
//    private lazy var costLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = R.color.primary87()
//        label.font = R.typo.body
//        label.numberOfLines = 1
//        return label
//    }()

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

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(typeLabel)
        containerView.addSubview(mentorNameLabel)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(mentorLabel)
        containerView.addSubview(descriptionHeaderLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(lessonInfoHeaderLabel)
        containerView.addSubview(timeImageView)
        containerView.addSubview(timeLabel)
//        containerView.addSubview(costImageView)
//        containerView.addSubview(costLabel)
        containerView.addSubview(contactImageView)
        containerView.addSubview(contactLabel)

        containerView.applyConstraints(
            .fitWithInsets(in: contentView, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        )

        titleLabel.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

        typeLabel.applyConstraints(
            .top(to: titleLabel, attribute: .bottom, constant: 4),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

        avatarImageView.applyConstraints(
            .top(to: typeLabel, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .width(constant: 64),
            .height(constant: 64)
        )

        mentorNameLabel.applyConstraints(
            .bottom(to: avatarImageView, attribute: .centerY, constant: -2),
            .leading(to: avatarImageView, attribute: .trailing, constant: 8),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

        mentorLabel.applyConstraints(
            .top(to: avatarImageView, attribute: .centerY, constant: 2),
            .leading(to: avatarImageView, attribute: .trailing, constant: 8),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

        descriptionHeaderLabel.applyConstraints(
            .top(to: avatarImageView, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

        descriptionLabel.applyConstraints(
            .top(to: descriptionHeaderLabel, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

        lessonInfoHeaderLabel.applyConstraints(
            .top(to: descriptionLabel, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

        timeImageView.applyConstraints(
            .top(to: lessonInfoHeaderLabel, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .width(constant: 32),
            .height(constant: 32)
        )

        timeLabel.applyConstraints(
            .centerY(to: timeImageView, attribute: .centerY),
            .leading(to: timeImageView, attribute: .trailing, constant: 8),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

//        costImageView.applyConstraints(
//            .top(to: timeImageView, attribute: .bottom, constant: 16),
//            .leading(to: containerView, attribute: .leading, constant: 16),
//            .width(constant: 32),
//            .height(constant: 32)
//        )
//
//        costLabel.applyConstraints(
//            .centerY(to: costImageView, attribute: .centerY),
//            .leading(to: costImageView, attribute: .trailing, constant: 8),
//            .trailing(to: containerView, attribute: .trailing, constant: -16)
//        )

        contactImageView.applyConstraints(
            .top(to: timeImageView, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .width(constant: 32),
            .height(constant: 32)
        )

        contactLabel.applyConstraints(
            .centerY(to: contactImageView, attribute: .centerY),
            .leading(to: contactImageView, attribute: .trailing, constant: 8),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .bottom(to: containerView, attribute: .bottom, constant: -16)
        )
    }

    func configureWith(item: Item) {
        titleLabel.text = item.name
        typeLabel.text = item.type
        mentorNameLabel.text = item.mentorName
        descriptionLabel.text = item.description
        timeLabel.text = item.time
//        costLabel.text = item.cost
        contactLabel.text = item.contact

        avatarImageView.kf.setImage(
            with: URL(string: item.mentorAvatarURL ?? ""),
            placeholder: nil
        )
    }

    func performBlink() {
        containerView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn, .autoreverse]) { [weak self] in
            self?.containerView.backgroundColor = R.color.brandPrimary()?.withAlphaComponent(0.3)
        } completion: { [weak self] finished in
            if finished {
                self?.containerView.backgroundColor = R.color.themePrimary()
            }
        }
    }
}

// MARK: - ViewModel

extension MyLessonsCell {
    struct Item {
        let id: String
        let lessonId: String
        let name: String
        let type: String
        let mentorName: String
        let mentorAvatarURL: String?
        let description: String
        let time: String
        let cost: String
        let contact: String
    }
}
