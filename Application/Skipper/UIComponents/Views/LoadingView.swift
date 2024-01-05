//
//  LoadingView.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2024.
//

import Foundation
import UIKit

class LoadingView: SetupableView {
    // MARK: - UI Controls

    private let progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = false
        return view
    }()

    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary100()
        label.font = R.typo.body
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Properties

    override var tintColor: UIColor! {
        get {
            progressView.color
        }
        set {
            progressView.color = newValue
            progressLabel.textColor = newValue
        }
    }

    // MARK: - Lifecycle

    override func setup() {
        addSubview(progressView)
        addSubview(progressLabel)

        progressView.applyConstraints(
            .top(to: self, attribute: .top),
            .leading(to: self, attribute: .leading, equality: .greaterThanOrEqual),
            .trailing(to: self, attribute: .trailing, equality: .lessThanOrEqual),
            .width(constant: 24),
            .height(constant: 24)
        )

        progressLabel.applyConstraints(
            .top(to: progressView, attribute: .bottom, constant: 4),
            .leading(to: self, attribute: .leading, equality: .greaterThanOrEqual),
            .trailing(to: self, attribute: .trailing, equality: .lessThanOrEqual),
            .bottom(to: self, attribute: .bottom)
        )
    }

    func startLoading() {
        progressView.startAnimating()
    }

    func stopLoading() {
        progressView.stopAnimating()
    }

    func updateProgress(_ progress: Int) {
        let normalizedProgress = min(max(0, progress), 100)

        progressLabel.text = "\(normalizedProgress)%"
    }
}
