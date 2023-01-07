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

        titleLabel?.font = R.typo.header
        layer.cornerRadius = 14
        contentEdgeInsets = .init(top: 5, left: 16, bottom: 5, right: 16)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        loadingIndicatorView.sizeToFit()
        loadingIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    // MARK: - UI Methods

    private func updateStyle() {
        backgroundColor = R.color.brandPrimary()?.withAlphaComponent(isHighlighted ? 0.7 : 1.0)
        setTitleColor(isHighlighted ? R.color.secondary70() : R.color.secondary100(), for: .normal)
    }

    private func updateLoadingState() {
        titleLabel?.isHidden = isLoading
        loadingIndicatorView.isHidden = !isLoading

        isUserInteractionEnabled = !isLoading
    }
}
