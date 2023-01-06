//
//  CircleImageView.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Foundation

class CircleImageView: SetupableImageView {
    override func setup() {
        super.setup()

        clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
    }
}
