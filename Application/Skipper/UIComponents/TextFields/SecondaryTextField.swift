//
//  SecondaryTextField.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import UIKit

class SecondaryTextField: InsetTextField {
    override func setup() {
        super.setup()

        contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)

        backgroundColor = R.color.themePrimary()
        font = R.typo.body
        textColor = R.color.primary87()

        layer.cornerRadius = 14
        layer.borderColor = R.color.brandPrimary()?.cgColor
        layer.borderWidth = 1
    }
}
