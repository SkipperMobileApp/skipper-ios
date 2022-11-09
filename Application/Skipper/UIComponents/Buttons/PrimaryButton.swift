//
//  PrimaryButton.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import UIKit

class PrimaryButton: SetupableButton {
    override func setup() {
        super.setup()

        backgroundColor = R.color.brandPrimary()
        setTitleColor(R.color.primary87(), for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.height / 2
    }
}
