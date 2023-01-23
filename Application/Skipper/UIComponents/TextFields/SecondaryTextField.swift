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

        contentInset = .init(top: 8, left: 16, bottom: 8, right: 16)

        backgroundColor = R.color.themeBackground()
        font = R.typo.body
        textColor = R.color.primary87()

        layer.cornerRadius = 14
        layer.borderColor = R.color.primary24()?.cgColor
        layer.borderWidth = 1
    }
}
