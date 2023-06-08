//
//  LessonInfoOptionView.swift
//  Skipper
//
//  Created by Denis Kovalev on 21.05.2023.
//

import Foundation
import UIKit

class LessonInfoOptionView: SetupableView {
    // MARK: - UI Controls

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    private var buttons: [UIControl] = []

    // MARK: - Output

    var didSelectOption: ((_ index: Int) -> Void)?
    var didDeselectOption: ((_ index: Int) -> Void)?

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        addSubview(stackView)

        stackView.applyConstraints(.fit(in: self))
    }

    func configure(with options: [Option]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        buttons = options.enumerated().map { index, option in
            let item = LessonInfoOptionItem()

            item.isSelected = option.isChecked
            item.configure(with: option.text, isChecked: option.isChecked)

            item.addAction(.init { [weak self] _ in
                self?.toggleOption(at: index)
            }, for: .touchUpInside)

            stackView.addArrangedSubview(item)

            return item
        }
    }

    private func toggleOption(at index: Int) {
        let isSelected = buttons[index].isSelected
        buttons[index].isSelected = !isSelected

        isSelected ? didDeselectOption?(index) : didSelectOption?(index)
    }
}

// MARK: - View Model

extension LessonInfoOptionView {
    struct Option {
        let text: String
        let isChecked: Bool
    }
}
