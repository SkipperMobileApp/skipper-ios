//
//  ChatInputView.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.01.2024.
//

import Foundation
import UIKit

class ChatInputView: SetupableView {
    // MARK: - Definitions

    private enum Constants {
        static let textViewMaxHeight: CGFloat = 65
    }

    // MARK: - UI Controls

    private let textView: PlaceholderTextView = {
        let textView = PlaceholderTextView()

        textView.backgroundColor = R.color.themeBackground()
        textView.textColor = R.color.primary87()
        textView.font = R.typo.body

        textView.placeholder = Strings.chatChatMessagesInputFieldPlaceholder()
        textView.placeholderFont = R.typo.body
        textView.placeholderTextColor = R.color.primary54()

        textView.keyboardType = .default
        textView.autocorrectionType = .default
        textView.autocapitalizationType = .sentences
        textView.returnKeyType = .default
        textView.textContentType = nil
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false

        return textView
    }()

    private lazy var attachmentButton: UIButton = {
        let button = UIButton()
        button.setImage(R.icon.attachment, for: .normal)
        button.tintColor = R.color.brandPrimary()
        button.addTarget(self, action: #selector(attachmentButtonAction), for: .touchUpInside)
        return button
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(R.icon.sendMessage, for: .normal)
        button.tintColor = R.color.brandPrimary()
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.isHidden = false
        return button
    }()

    private lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = R.color.brandPrimary()
        view.hidesWhenStopped = true
        view.style = .medium
        return view
    }()

    private var textViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Output

    var didTapSend: ((_ text: String) -> Void)?
    var didTapAttachment: (() -> Void)?

    // MARK: - UI Methods

    override func setup() {
        backgroundColor = R.color.themeBackground()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: -1)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 1

        addSubview(textView)
        addSubview(sendButton)
        addSubview(attachmentButton)
        addSubview(loaderView)

        attachmentButton.applyConstraints(
            .leading(to: self, attribute: .leading, constant: 16),
            .bottom(to: self, attribute: .bottom, constant: -13),
            .width(constant: 24),
            .height(constant: 24)
        )

        sendButton.applyConstraints(
            .trailing(to: self, attribute: .trailing, constant: -16),
            .bottom(to: self, attribute: .bottom, constant: -13),
            .width(constant: 24),
            .height(constant: 24)
        )

        loaderView.applyConstraints(
            .fit(in: sendButton)
        )

        textViewHeightConstraint = textView.applyConstraints(
            .top(to: self, attribute: .top, constant: 8),
            .leading(to: attachmentButton, attribute: .trailing, constant: 8),
            .trailing(to: sendButton, attribute: .leading, constant: -8),
            .bottom(to: self, attribute: .bottom, constant: -8),
            .height(constant: 34)
        ).last!

        setupTextView()
    }

    private func setupTextView() {
        textView.didChangeText = { [weak self] _ in
            self?.adjustTextViewSize()
        }
    }

    private func adjustTextViewSize() {
        let width = textView.frame.width
        let height = textView.sizeThatFits(
            .init(width: width, height: .greatestFiniteMagnitude)
        ).height

        if textViewHeightConstraint.constant == height {
            return
        }

        textViewHeightConstraint.constant = min(height, Constants.textViewMaxHeight)
    }

    // MARK: - Public

    func configure(with text: String) {
        textView.text = text
    }

    func setLoading(_ isLoading: Bool) {
        sendButton.isHidden = isLoading
        isLoading ? loaderView.startAnimating() : loaderView.stopAnimating()
    }

    func clearInput() {
        textView.text = ""
        textView.textViewDidChange(textView)
    }

    // MARK: - UI Callbacks

    @objc private func sendButtonAction() {
        didTapSend?(textView.text)
    }

    @objc private func attachmentButtonAction() {
        didTapAttachment?()
    }
}
