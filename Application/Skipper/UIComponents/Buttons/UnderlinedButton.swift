//
//  UnderlinedButton.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.11.2022.
//

import UIKit

class UnderlinedButton: SetupableButton {
    // MARK: - Properties

    override var isHighlighted: Bool {
        didSet {
            updateStyle()
        }
    }

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        updateStyle()

        titleLabel?.font = R.typo.header3
        backgroundColor = .clear
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)

        setAttributedTitle(title.flatMap(underlineString), for: state)
    }

    private func updateStyle() {
        setTitleColor(isHighlighted ? R.color.gray50() : R.color.gray70(), for: .normal)
    }

    // MARK: - Utils

    private func underlineString(_ string: String) -> NSAttributedString {
        .init(string: string, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
}
