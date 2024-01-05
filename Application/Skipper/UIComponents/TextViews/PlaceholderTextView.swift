//
//  PlaceholderTextView.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.01.2024.
//

import Foundation
import UIKit

class PlaceholderTextView: SetupableTextView {
    // MARK: - Output

    var didChangeText: ((_ textView: UITextView) -> Void)?
    var didBeginEditing: ((_ textView: UITextView) -> Void)?
    var didEndEditing: ((_ textView: UITextView) -> Void)?
    var shouldBeginEditing: ((_ textView: UITextView) -> Bool)?
    var shouldEndEditing: ((_ textView: UITextView) -> Bool)?
    var didChangeSelection: ((_ textView: UITextView) -> Void)?

    // MARK: - UI Controls

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = placeholder
        label.textColor = placeholderTextColor
        label.font = placeholderFont
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        return label
    }()

    // MARK: - Properties

    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    var placeholderTextColor: UIColor? = R.color.primary54() {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }

    var placeholderFont: UIFont = R.typo.body {
        didSet {
            placeholderLabel.font = placeholderFont
        }
    }

    override var contentInset: UIEdgeInsets {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        let contentWidth = frame.width - adjustedContentInset.left - adjustedContentInset.right
        let contentHeight = frame.height - adjustedContentInset.top - adjustedContentInset.bottom

        let placeholderSize = placeholderLabel.sizeThatFits(
            .init(width: contentWidth, height: .greatestFiniteMagnitude)
        )

        placeholderLabel.frame = .init(
            x: adjustedContentInset.left + 6,
            y: adjustedContentInset.top + 8,
            width: contentWidth,
            height: min(placeholderSize.height, contentHeight)
        )
    }

    override func setup() {
        addSubview(placeholderLabel)

        delegate = self
    }
}

// MARK: - UITextViewDelegate

extension PlaceholderTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        didChangeText?(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditing?(textView)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditing?(textView)
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        shouldEndEditing?(textView) ?? true
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        shouldBeginEditing?(textView) ?? true
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        didChangeSelection?(textView)
    }
}
