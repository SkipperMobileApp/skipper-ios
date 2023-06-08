//
//  LessonInfoTimeItem.swift
//  Skipper
//
//  Created by Denis Kovalev on 21.05.2023.
//

import Foundation
import UIKit

protocol LessonInfoTimeItemDelegate: AnyObject {
    func itemDidTapDayTime(_ item: LessonInfoTimeItem)
    func itemDidTapDelete(_ item: LessonInfoTimeItem)
}

class LessonInfoTimeItem: SetupableView {
    // MARK: - UI Controls

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()

    private lazy var dayButton: DropdownButton = {
        let button = DropdownButton()
        button.addTarget(self, action: #selector(dayButtonAction), for: .touchUpInside)
        return button
    }()

    private lazy var timeButton: DropdownButton = {
        let button = DropdownButton()
        button.addTarget(self, action: #selector(timeButtonAction), for: .touchUpInside)
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(R.icon.trash, for: .normal)
        button.tintColor = R.color.brandError()
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    weak var delegate: LessonInfoTimeItemDelegate?

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        addSubview(stackView)
        addSubview(deleteButton)

        stackView.addArrangedSubview(dayButton)
        stackView.addArrangedSubview(timeButton)

        stackView.applyConstraints(
            .top(to: self, attribute: .top),
            .bottom(to: self, attribute: .bottom),
            .leading(to: self, attribute: .leading),
            .height(constant: 40)
        )

        deleteButton.applyConstraints(
            .centerY(to: stackView, attribute: .centerY),
            .leading(
                to: stackView,
                attribute: .trailing,
                constant: 8
            ),
            .trailing(to: self, attribute: .trailing),
            .height(constant: 32),
            .width(constant: 32)
        )
    }

    func configure(viewModel: ViewModel) {
        dayButton.text = viewModel.day ?? "День"
        timeButton.text = viewModel.time ?? "Время"
    }

    // MARK: - UI Callbacks

    @objc private func dayButtonAction() {
        delegate?.itemDidTapDayTime(self)
    }

    @objc private func timeButtonAction() {
        delegate?.itemDidTapDayTime(self)
    }

    @objc private func deleteAction() {
        delegate?.itemDidTapDelete(self)
    }
}

// MARK: - View Model

extension LessonInfoTimeItem {
    struct ViewModel {
        let day: String?
        let time: String?
    }
}
