//
//  DropdownButton.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation
import UIKit

class DropdownButton: SetupableControl {
    // MARK: - Definitions

    private enum Constants {
        static let imageSize = CGSize(width: 6, height: 12)
        static let innerInset: CGFloat = 4
    }

    // MARK: - UI Controls

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.body
        label.numberOfLines = 1
        return label
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.body
        label.numberOfLines = 1
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = R.color.brandPrimary()
        imageView.image = R.icon.arrowRight
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    // MARK: - Properties

    var contentInset: UIEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8) {
        didSet {
            invalidateIntrinsicContentSize()
            layoutIfNeeded()
        }
    }

    var text: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
            updateAppearance()
            invalidateIntrinsicContentSize()
        }
    }

    var placeholder: String? {
        get {
            placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel.sizeThatFits(.init(
            width: CGFloat.greatestFiniteMagnitude,
            height: .greatestFiniteMagnitude
        ))
        let placeholderSize = placeholderLabel.sizeThatFits(.init(
            width: CGFloat.greatestFiniteMagnitude,
            height: .greatestFiniteMagnitude
        ))

        let imageSize = Constants.imageSize
        let innerInset = Constants.innerInset

        return .init(
            width: contentInset.left + max(titleSize.width, placeholderSize.width) + innerInset + imageSize.width + contentInset.right,
            height: contentInset.top + max(titleSize.height, placeholderSize.height) + contentInset.bottom
        )
    }

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        layer.cornerRadius = 12
        layer.borderColor = R.color.brandPrimary()?.cgColor
        layer.borderWidth = 1

        backgroundColor = R.color.themePrimary()

        addSubview(titleLabel)
        addSubview(placeholderLabel)
        addSubview(arrowImageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let (width, height) = (bounds.width, bounds.height)
        let innerInset = Constants.innerInset
        let imageSize = Constants.imageSize
        let textWidth = width - contentInset.left - contentInset.right - imageSize.width - innerInset

        arrowImageView.frame = .init(
            x: width - contentInset.right - imageSize.width,
            y: (height - imageSize.height) / 2,
            width: imageSize.width,
            height: imageSize.height
        )

        titleLabel.frame = .init(
            x: contentInset.left,
            y: 0,
            width: textWidth,
            height: height
        )

        placeholderLabel.frame = .init(
            x: contentInset.left,
            y: 0,
            width: textWidth,
            height: height
        )
    }

    // MARK: - UI Methods

    private func updateAppearance() {
        placeholderLabel.isHidden = titleLabel.text != nil
        titleLabel.isHidden = titleLabel.text == nil
    }
}
