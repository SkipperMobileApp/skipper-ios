//
//  DashboardSectionHeaderView.swift
//  Skipper
//
//  Created by Denis Kovalev on 03.01.2023.
//

import Foundation
import Reusable
import UIKit

class DashboardSectionHeaderView: SetupableCollectionReusableView, Reusable {
    // MARK: - UI Controls

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = R.color.primary87()
        label.font = R.typo.header2
        return label
    }()

    // MARK: - Properties

    var title: String {
        get {
            titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        addSubview(titleLabel)

        titleLabel.applyConstraints(
            .top(to: self, attribute: .top),
            .bottom(to: self, attribute: .bottom),
            .leading(to: self, attribute: .leading, constant: 8),
            .trailing(to: self, attribute: .trailing, constant: -8)
        )
    }
}
