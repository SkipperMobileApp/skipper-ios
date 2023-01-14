//
//  MentorProfileHeaderView.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation
import UIKit

class MentorProfileHeaderView: SetupableView {
    // MARK: - UI Controls

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.header2
        label.textColor = R.color.primary87()
        label.numberOfLines = 1
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = R.typo.subheader
        button.setTitleColor(R.color.brandSecondary(), for: .normal)
        button.setTitleColor(R.color.brandSecondary()?.withAlphaComponent(0.6), for: .highlighted)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Output

    var didTapButton: (() -> Void)?

    // MARK: - Properties

    var title: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }

    var buttonTitle: String {
        get { button.title(for: .normal) ?? "" }
        set { button.setTitle(newValue, for: .normal) }
    }

    var isButtonHidden: Bool {
        get { button.isHidden }
        set { button.isHidden = newValue }
    }

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        addSubview(titleLabel)
        addSubview(button)

        titleLabel.applyConstraints(
            .leading(to: self, attribute: .leading),
            .top(to: self, attribute: .top),
            .bottom(to: self, attribute: .bottom),
            .trailing(to: button, attribute: .leading, constant: -16, equality: .lessThanOrEqual)
        )

        button.applyConstraints(
            .trailing(to: self, attribute: .trailing),
            .centerY(to: titleLabel, attribute: .centerY)
        )
    }

    // MARK: - UI Callbacks

    @objc private func buttonAction() {
        didTapButton?()
    }
}
