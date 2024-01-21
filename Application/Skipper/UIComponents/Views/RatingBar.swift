//
//  RatingBar.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2024.
//

import Foundation
import UIKit

class RatingBar: SetupableView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    // MARK: - Output

    var didChangeRating: ((_ rating: Int) -> Void)?

    // MARK: - Properties

    private var buttons: [UIButton] = []

    private(set) var rating: Int = 0

    var selectedTintColor: UIColor = R.color.brandPrimary()! {
        didSet {
            updateButtonsAppearance(for: rating)
        }
    }

    var normalTintColor: UIColor = R.color.primary12()! {
        didSet {
            updateButtonsAppearance(for: rating)
        }
    }

    override func setup() {
        super.setup()

        addSubview(stackView)
        stackView.applyConstraints(.fit(in: self))

        buttons = (1 ... 5).map { rating in

            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            button.tintColor = normalTintColor
            button.imageView?.contentMode = .scaleAspectFit
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill

            button.addAction(.init { [weak self] _ in
                self?.didChangeRating?(rating)
                self?.rating = rating
                self?.updateButtonsAppearance(for: rating)
            }, for: .touchUpInside)

            stackView.addArrangedSubview(button)

            button.applyConstraints(
                .height(constant: 44),
                .width(constant: 44)
            )

            return button
        }

        updateButtonsAppearance(for: rating)
    }

    func configure(with rating: Int) {
        updateButtonsAppearance(for: rating)
    }

    private func updateButtonsAppearance(for rating: Int) {
        buttons.enumerated().forEach { index, button in
            button.tintColor = index < rating ? selectedTintColor : normalTintColor
        }
    }
}
