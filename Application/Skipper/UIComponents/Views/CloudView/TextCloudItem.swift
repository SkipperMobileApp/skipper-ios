//
//  TextCloudItem.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2023.
//

import Foundation
import UIKit

class TextCloudItem: SetupableControl, CloudItem {
    // MARK: - UI Controls

    private lazy var label = UILabel()

    // MARK: - Properties

    var text: String {
        get { label.text ?? "" }
        set { label.text = newValue }
    }

    var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }

    var textColor: UIColor {
        get { label.textColor }
        set { label.textColor = newValue }
    }

    var contentInset: UIEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = bounds.inset(by: contentInset)

        layer.cornerRadius = bounds.height / 2
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = label.sizeThatFits(size)
        return .init(
            width: contentInset.left + size.width + contentInset.right,
            height: contentInset.top + size.height + contentInset.bottom
        )
    }
}
