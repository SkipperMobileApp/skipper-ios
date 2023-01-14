//
//  StatusItemView.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Foundation
import UIKit

class StatusItemView: SetupableView {
    // MARK: - UI Controls

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.header
        label.textColor = R.color.primary87()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.body
        label.textColor = R.color.primary54()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    // MARK: - Properties

    var contentInset: UIEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude,
                                                      height: .greatestFiniteMagnitude))

        let subtitleSize = subtitleLabel.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude,
                                                            height: .greatestFiniteMagnitude))

        return .init(width: contentInset.left + max(titleSize.width, subtitleSize.width) + contentInset.right,
                     height: contentInset.top + titleSize.height + 4 + subtitleSize.height + contentInset.bottom)
    }

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let availableWidth = bounds.width - contentInset.left - contentInset.right

        let titleHeight = titleLabel.sizeThatFits(.init(width: availableWidth,
                                                        height: .greatestFiniteMagnitude)).height
        let subtitleHeight = subtitleLabel.sizeThatFits(.init(width: availableWidth,
                                                              height: .greatestFiniteMagnitude)).height

        titleLabel.frame = .init(x: contentInset.left,
                                 y: contentInset.top,
                                 width: availableWidth,
                                 height: titleHeight)

        subtitleLabel.frame = .init(x: contentInset.left,
                                    y: titleLabel.frame.maxY + 4,
                                    width: availableWidth,
                                    height: subtitleHeight)
    }

    // MARK: - UI Methods

    func configureWith(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle

        invalidateIntrinsicContentSize()
    }
}
