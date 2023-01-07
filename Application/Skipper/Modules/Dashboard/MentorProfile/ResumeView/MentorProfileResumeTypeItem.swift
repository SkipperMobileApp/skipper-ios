//
//  MentorProfileResumeTypeItem.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Foundation
import UIKit

class MentorProfileResumeTypeItem: SetupableView {
    // MARK: - UI Controls

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = R.color.brandPrimary()
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.subheader
        label.textColor = R.color.primary87()
        label.numberOfLines = 1
        return label
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.primary12()
        view.layer.cornerRadius = 1.5
        return view
    }()

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(lineView)
        addSubview(stackView)

        imageView.applyConstraints(
            .leading(to: self, attribute: .leading),
            .top(to: self, attribute: .top),
            .height(constant: 44),
            .width(constant: 44)
        )

        titleLabel.applyConstraints(
            .leading(to: imageView, attribute: .trailing, constant: 8),
            .trailing(to: self, attribute: .trailing),
            .centerY(to: imageView, attribute: .centerY)
        )

        lineView.applyConstraints(
            .top(to: imageView, attribute: .bottom, constant: 12),
            .bottom(to: self, attribute: .bottom, constant: -12),
            .centerX(to: imageView, attribute: .centerX),
            .width(constant: 3)
        )

        stackView.applyConstraints(
            .top(to: titleLabel, attribute: .bottom, constant: 8),
            .leading(to: imageView, attribute: .trailing, constant: 8),
            .trailing(to: self, attribute: .trailing),
            .bottom(to: self, attribute: .bottom)
        )
    }

    func configureWith(title: String, icon: UIImage, items: [Item]) {
        titleLabel.text = title
        imageView.image = icon

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        items
            .map {
                let view = MentorProfileResumeItem()
                view.configureWith(title: $0.title, subtitle: $0.subtitle)
                return view
            }
            .forEach {
                stackView.addArrangedSubview($0)
            }
    }
}

extension MentorProfileResumeTypeItem {
    struct Item {
        let title: String
        let subtitle: String
    }
}
