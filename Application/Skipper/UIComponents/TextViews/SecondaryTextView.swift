//
//  SecondaryTextView.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.01.2023.
//

import Foundation

class SecondaryTextView: SetupableTextView {
    override func setup() {
        super.setup()

        showsVerticalScrollIndicator = false

        textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)

        backgroundColor = R.color.themeBackground()
        textColor = R.color.primary87()
        font = R.typo.body

        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = R.color.primary24()?.cgColor
    }
}
