//
//  CheckboxButton.swift
//  Skipper
//
//  Created by Denis Kovalev on 21.05.2023.
//

import Foundation

class CheckboxButton: SetupableButton {
    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        setImage(R.icon.checkboxOn.withTintColor(R.color.brandPrimary()!), for: .selected)
        setImage(R.icon.checkboxOff.withTintColor(R.color.brandPrimary()!), for: .normal)

        setTitleColor(R.color.primary87(), for: .normal)
        titleLabel?.font = R.typo.body1

        imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 16)
    }
}
