//
//  LessonInfoTimeView.swift
//  Skipper
//
//  Created by Denis Kovalev on 21.05.2023.
//

import Foundation
import UIKit

class LessonInfoTimeView: SetupableView {
    // MARK: - UI Controls

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()

    private var items: [LessonInfoTimeItem] = []

    // MARK: - Output

    var didDeleteTime: ((_ index: Int) -> Void)?
    var didSelectTime: ((_ index: Int) -> Void)?
    var didAddTime: (() -> Void)?

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        addSubview(stackView)

        stackView.applyConstraints(.fit(in: self))
    }

    func configure(with times: [TimeItem]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        items = times.map { item in
            let itemView = makeItem(for: item)
            stackView.addArrangedSubview(itemView)
            return itemView
        }

        stackView.addArrangedSubview(makeAddButton())
    }

    func updateItem(at index: Int, with time: TimeItem) {
        guard let itemView = items[safe: index] else { return }

        itemView.configure(viewModel: .init(day: time.day, time: time.time))
    }

    func deleteItem(at index: Int) {
        guard let itemView = items[safe: index] else { return }

        itemView.removeFromSuperview()
        items.remove(at: index)
    }

    func addItem() {
        let item = makeItem(for: .init(day: nil, time: nil))
        items.append(item)

        stackView.insertArrangedSubview(item, at: stackView.arrangedSubviews.count - 1)
    }

    // MARK: - UI Builders

    private func makeItem(for item: TimeItem) -> LessonInfoTimeItem {
        let itemView = LessonInfoTimeItem()
        itemView.configure(viewModel: .init(day: item.day, time: item.time))
        itemView.delegate = self
        return itemView
    }

    private func makeAddButton() -> UIView {
        let button = SecondaryButton()
        button.setTitle("Добавить время", for: .normal)
        button.addTarget(self, action: #selector(addItemAction), for: .touchUpInside)

        let containerView = UIView()
        containerView.addSubview(button)

        button.applyConstraints(
            .fit(in: containerView),
            .height(constant: 45)
        )

        return containerView
    }

    // MARK: - UI Callbacks

    @objc private func addItemAction() {
        didAddTime?()
    }
}

// MARK: - LessonInfoTimeItemDelegate

extension LessonInfoTimeView: LessonInfoTimeItemDelegate {
    func itemDidTapDelete(_ item: LessonInfoTimeItem) {
        guard let index = items.firstIndex(of: item) else { return }

        didDeleteTime?(index)
    }

    func itemDidTapDayTime(_ item: LessonInfoTimeItem) {
        guard let index = items.firstIndex(of: item) else { return }

        didSelectTime?(index)
    }
}

// MARK: - View Model

extension LessonInfoTimeView {
    struct TimeItem {
        let day: String?
        let time: String?
    }
}
