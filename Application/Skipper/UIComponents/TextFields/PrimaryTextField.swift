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

        contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)

        backgroundColor = R.color.themeSecondary()
        font = R.typo.body1
        textColor = R.color.primary87()

        layer.cornerRadius = 14
    }
}
