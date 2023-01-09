//
//  BookingContactItemView.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation
import UIKit

class BookingContactItemView: SetupableView {
    // MARK: - UI Controls

    private lazy var imageView: UIImageView = {
        let imageView = CircleImageView()
        imageView.tintColor = R.color.primary24()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var valueField: UITextField = {
        let field = SecondaryTextField()
        return field
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Properties

    var value: String {
        get { valueField.text ?? "" }
        set { valueField.text = newValue }
    }

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        addSubview(imageView)
        addSubview(valueField)
        addSubview(titleLabel)

        imageView.applyConstraints(
            .top(to: self, attribute: .top, constant: 8),
            .leading(to: self, attribute: .leading, constant: 16),
            .bottom(to: self, attribute: .bottom, constant: -16),
            .height(constant: 80),
            .width(constant: 80)
        )

        titleLabel.applyConstraints(
            .top(to: self, attribute: .top, constant: 12),
            .leading(to: imageView, attribute: .trailing, constant: 16),
            .trailing(to: self, attribute: .trailing, constant: -16)
        )

        valueField.applyConstraints(
            .top(to: titleLabel, attribute: .bottom, constant: 8),
            .leading(to: imageView, attribute: .trailing, constant: 16),
            .trailing(to: self, attribute: .trailing, constant: -16),
            .height(constant: 40)
        )
    }

    func configureWith(title: String, imageURL: String?, fieldPlaceholder: String) {
        titleLabel.text = title
        valueField.placeholder = fieldPlaceholder

        imageView.kf.setImage(with: URL(string: imageURL ?? ""), placeholder: nil)
    }
}
