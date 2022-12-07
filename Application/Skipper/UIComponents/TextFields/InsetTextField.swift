//
//  InsetTextField.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.11.2022.
//

import UIKit

class InsetTextField: SetupableTextField {
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }

    override func setup() {
        super.setup()
    }

    // MARK: - Inset

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds.inset(by: contentInset))
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds.inset(by: contentInset))
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        super.rightViewRect(forBounds: bounds.inset(by: contentInset))
    }

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        super.clearButtonRect(forBounds: bounds.inset(by: contentInset))
    }
}
