//
//  PasswordSecondaryTextField.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.01.2023.
//

import UIKit

class PasswordSecondaryTextField: SecondaryTextField {
    private lazy var togglePasswordButton: UIButton = {
        let button = UIButton()
        button.setImage(R.icon.eye, for: .normal)
        button.tintColor = R.color.gray70()
        button.frame = CGRect(x: 0, y: 0, width: 26, height: 16)

        button.addTarget(self, action: #selector(togglePasswordAction), for: .touchUpInside)

        return button
    }()

    override func setup() {
        super.setup()

        isSecureTextEntry = true

        rightView = togglePasswordButton
        rightViewMode = .always
    }

    @objc private func togglePasswordAction() {
        isSecureTextEntry.toggle()
        togglePasswordButton.setImage(
            isSecureTextEntry ? R.icon.eye : R.icon.eyeSlashed,
            for: .normal
        )
    }
}
