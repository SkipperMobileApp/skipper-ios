//
//  BookingHeaderView.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation
import Reusable
import UIKit

class BookingHeaderView: SetupableView, Reusable {
    // MARK: - UI Controls

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header4
        label.numberOfLines = 1
        return label
    }()

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        addSubview(titleLabel)
        titleLabel.applyConstraints(
            .centerY(to: self, attribute: .centerY),
            .leading(to: self, attribute: .leading, constant: 16),
            .trailing(to: self, attribute: .trailing, constant: -16),
            .top(to: self, attribute: .top, constant: 4, equality: .greaterThanOrEqual),
            .bottom(to: self, attribute: .bottom, constant: -4, equality: .lessThanOrEqual)
        )
    }

    func configureWith(title: String) {
        titleLabel.text = title
    }
}
