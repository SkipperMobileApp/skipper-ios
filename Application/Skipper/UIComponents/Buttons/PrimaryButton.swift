//
//  PrimaryButton.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import UIKit

class PrimaryButton: SetupableButton {
    override var isHighlighted: Bool {
        didSet {
            updateStyle()
        }
    }

    override func setup() {
        super.setup()

        updateStyle()

        titleLabel?.font = R.typo.header2
        layer.cornerRadius = 6
    }

    private func updateStyle() {
        backgroundColor = R.color.brandPrimary()?.withAlphaComponent(isHighlighted ? 0.7 : 1.0)
        setTitleColor(isHighlighted ? R.color.primary87() : R.color.primary100(), for: .normal)
    }
}
