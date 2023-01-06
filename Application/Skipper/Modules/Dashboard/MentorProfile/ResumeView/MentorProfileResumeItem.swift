//
//  MentorProfileResumeItem.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Foundation
import UIKit

class MentorProfileResumeItem: SetupableView {
    // MARK: - UI Controls

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.body
        label.textColor = R.color.primary87()
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.body
        label.textColor = R.color.primary54()
        label.numberOfLines = 0
        return label
    }()

    // MARK: - UI methods

    override func setup() {
        super.setup()

        addSubview(titleLabel)
        addSubview(subtitleLabel)

        titleLabel.applyConstraints(
            .top(to: self, attribute: .top),
            .leading(to: self, attribute: .leading),
            .trailing(to: self, attribute: .trailing)
        )

        subtitleLabel.applyConstraints(
            .top(to: titleLabel, attribute: .bottom, constant: 4),
            .leading(to: self, attribute: .leading),
            .trailing(to: self, attribute: .trailing),
            .bottom(to: self, attribute: .bottom)
        )
    }

    func configureWith(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
