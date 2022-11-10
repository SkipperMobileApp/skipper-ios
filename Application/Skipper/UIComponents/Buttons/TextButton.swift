//
//  TextButton.swift
//  Skipper
//
//  Created by Denis Kovalev on 11.11.2022.
//

import UIKit

class TextButton: SetupableButton {
    override var isHighlighted: Bool {
        didSet {
            updateStyle()
        }
    }

    override func setup() {
        super.setup()

        updateStyle()

        titleLabel?.font = R.typo.header3
        backgroundColor = .clear
    }

    private func updateStyle() {
        setTitleColor(isHighlighted ? R.color.gray50() : R.color.gray70(), for: .normal)
    }
}
