//
//  MentorProfileClassesView.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Foundation
import UIKit

class MentorProfileClassesView: SetupableView {
    // MARK: - UI Controls

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Output

    var didSelectItemAtIndex: ((_ index: Int) -> Void)?

    // MARK: - Properties

    private var items: [Item] = []

    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: stackView.intrinsicContentSize.height)
    }

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        addSubview(stackView)
        stackView.applyConstraints(.fit(in: self))
    }

    func configureWith(items: [Item]) {
        self.items = items

        reloadData()
    }

    func reloadData() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        items.indices
            .map { index in
                let itemView = MentorProfileClassItem()
                let item = items[index]
                itemView.configureWith(title: item.title, description: item.description)
                itemView.addAction(.init { [weak self, weak itemView] _ in
                    self?.didSelectItemAtIndex?(index)
                    itemView?.performBlink()
                }, for: .touchUpInside)
                return itemView
            }
            .forEach {
                stackView.addArrangedSubview($0)
            }

        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
}

// MARK: - View Model

extension MentorProfileClassesView {
    struct Item {
        let title: String
        let description: String
    }
}
