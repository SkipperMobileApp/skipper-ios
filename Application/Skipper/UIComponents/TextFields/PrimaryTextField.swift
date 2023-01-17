//
//  PrimaryTextField.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.11.2022.
//

import UIKit

class PrimaryTextField: InsetTextField {
    override func setup() {
        super.setup()

        contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)

        backgroundColor = R.color.themeSecondary()
        font = R.typo.body
        textColor = R.color.primary87()

        layer.cornerRadius = 14
    }
}
