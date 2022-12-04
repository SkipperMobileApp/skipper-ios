//
//  PrimaryButton.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import UIKit

class PrimaryButton: SetupableButton {
    // MARK: - UI Controls

    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        return view
    }()

    // MARK: - Properties

    override var isHighlighted: Bool {
        didSet {
            updateStyle()
        }
    }

    var isLoading: Bool = false {
        didSet {
            updateLoadingState()
        }
    }

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        updateStyle()
        updateLoadingState()

        titleLabel?.font = R.typo.header2
        layer.cornerRadius = 14
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        loadingIndicatorView.sizeToFit()
        loadingIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    // MARK: - UI Methods

    private func updateStyle() {
        backgroundColor = R.color.brandPrimary()?.withAlphaComponent(isHighlighted ? 0.7 : 1.0)
        setTitleColor(isHighlighted ? R.color.primary87() : R.color.primary100(), for: .normal)
    }

    private func updateLoadingState() {
        titleLabel?.isHidden = isLoading
        loadingIndicatorView.isHidden = !isLoading

        isUserInteractionEnabled = !isLoading
    }
}
