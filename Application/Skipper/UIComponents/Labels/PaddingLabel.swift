//
//  PaddingLabel.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.11.2022.
//

import UIKit

class PaddingLabel: SetupableLabel {
    var contentInset: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: contentInset.left + size.width + contentInset.right,
            height: contentInset.top + size.height + contentInset.bottom
        )
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - contentInset.left - contentInset.right
        }
    }
}
