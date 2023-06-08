//
//  LessonManagementCell.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.04.2023.
//

import Foundation
import Reusable
import UIKit

class LessonManagementCell: SetupableTableViewCell, Reusable {
    // MARK: - Definitions

    private enum Constants {
        static let contentInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let edgeInsets: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
    }

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

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)

        containerView.applyConstraints(
            .fitWithInsets(in: contentView, insets: Constants.edgeInsets)
        )

        let insets = Constants.contentInsets

        titleLabel.applyConstraints(
            .top(to: containerView, attribute: .top, constant: insets.top),
            .leading(to: containerView, attribute: .leading, constant: insets.left),
            .trailing(to: containerView, attribute: .trailing, constant: -insets.right)
        )

        descriptionLabel.applyConstraints(
            .top(to: titleLabel, attribute: .bottom, constant: 8),
            .leading(to: containerView, attribute: .leading, constant: insets.left),
            .trailing(to: containerView, attribute: .trailing, constant: -insets.right),
            .bottom(to: containerView, attribute: .bottom, constant: -insets.bottom)
        )
    }

    func configureWith(model: ViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }

    func performBlink() {
        containerView.layer.removeAllAnimations()
        UIView
            .animate(
                withDuration: 0.15,
                delay: 0,
                options: [.curveEaseIn, .autoreverse]
            ) { [weak self] in
                self?.containerView.backgroundColor = R.color.brandPrimary()?
                    .withAlphaComponent(0.3)
            } completion: { [weak self] finished in
                if finished {
                    self?.containerView.backgroundColor = R.color.themePrimary()
                }
            }
    }
}

extension LessonManagementCell {
    struct ViewModel {
        let lessonId: String
        let title: String
        let description: String
    }
}
