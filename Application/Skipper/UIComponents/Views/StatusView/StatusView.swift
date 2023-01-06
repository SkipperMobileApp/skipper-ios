//
//  StatusView.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Foundation
import UIKit

class StatusView: SetupableView {
    // MARK: - UI Lifecycle

    private var views: [StatusItemView] = []
    private var separators: [UIView] = []

    override var intrinsicContentSize: CGSize {
        let height = views.map(\.intrinsicContentSize.height).max() ?? 0
        return .init(width: UIView.noIntrinsicMetric, height: height)
    }

    override func setup() {
        super.setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var currentX: CGFloat = 0
        let viewWidth = (bounds.width - Double(separators.count)) / Double(views.count)
        let separatorHeight = bounds.height * 0.5
        let separatorY = (bounds.height - separatorHeight) / 2

        for i in 0 ..< views.count {
            let view = views[i]
            let separator = i < separators.count ? separators[i] : nil

            let viewHeight = view.intrinsicContentSize.height
            view.frame = .init(x: currentX,
                               y: (bounds.height - viewHeight) / 2,
                               width: viewWidth,
                               height: viewHeight)

            separator?.frame = .init(x: view.frame.maxX + 1,
                                     y: separatorY,
                                     width: 1,
                                     height: separatorHeight)

            currentX += viewWidth + (separator.flatMap { _ in 1 } ?? 0)
        }
    }

    func configure(with items: [StatusItem]) {
        subviews.forEach { $0.removeFromSuperview() }

        views = items.map {
            let view = StatusItemView()
            view.configureWith(title: $0.title, subtitle: $0.subtitle)
            return view
        }

        separators = views
            .map { _ in
                let view = UIView()
                view.backgroundColor = R.color.primary12()
                return view
            }
            .dropLast()

        (views + separators).forEach { addSubview($0) }

        invalidateIntrinsicContentSize()
    }
}

extension StatusView {
    struct StatusItem {
        let title: String
        let subtitle: String
    }
}
