//
//  BookingTimeSectionHeader.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation
import Reusable
import UIKit

class BookingTimeSectionHeader: SetupableTableViewHeaderFooterView, Reusable {
    // MARK: - UI Controls

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary54()
        label.font = R.typo.header
        label.numberOfLines = 1
        return label
    }()

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        contentView.addSubview(titleLabel)
        titleLabel.applyConstraints(
            .fitWithInsets(in: contentView, insets: .init(top: 8, left: 24, bottom: 8, right: 16))
        )
    }

    func configureWith(title: String) {
        titleLabel.text = title
    }
}
