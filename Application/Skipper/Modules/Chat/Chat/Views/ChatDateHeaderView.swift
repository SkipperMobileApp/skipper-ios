//
//  ChatDateHeaderView.swift
//  Skipper
//
//  Created by Denis Kovalev on 01.01.2024.
//

import Foundation
import Reusable
import UIKit

class ChatDateHeaderView: SetupableTableViewHeaderFooterView, Reusable {
    // MARK: - UI Controls

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.secondary100()
        label.font = R.typo.caption2
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.gray50()
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.layer.cornerRadius = (frame.height - 16) / 2
    }

    // MARK: - UI Methods

    override func setup() {
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)

        containerView.applyConstraints(
            .top(to: contentView, attribute: .top, constant: 8),
            .centerX(to: contentView, attribute: .centerX),
            .bottom(to: contentView, attribute: .bottom, constant: -8)
        )

        dateLabel.applyConstraints(
            .fitWithInsets(in: containerView, insets: .init(top: 4, left: 8, bottom: 4, right: 8))
        )

        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    func configure(with model: ViewModel) {
        dateLabel.text = model.date
    }
}

// MARK: - ViewModel

extension ChatDateHeaderView {
    struct ViewModel: Hashable {
        let date: String
    }
}
