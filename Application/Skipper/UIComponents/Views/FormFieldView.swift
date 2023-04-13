//
//  FormFieldView.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.11.2022.
//

import Foundation
import UIKit

protocol FormFieldViewDelegate: AnyObject {
    func formFieldViewDidChangeText(_ view: FormFieldView, newText: String?)
    func formFieldViewShouldReturn(_ view: FormFieldView)
}

class FormFieldView: SetupableView {
    // MARK: - UI Controls

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var textField: PrimaryTextField = {
        let textField = PrimaryTextField()
        textField.borderStyle = .none
        textField.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        textField.rightView = togglePasswordButton

        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)

        return textField
    }()

    private lazy var errorLabel: UILabel = {
        let label = PaddingLabel()
        label.font = R.typo.caption
        label.textColor = R.color.brandError()
        label.text = ""
        label.numberOfLines = 0
        label.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return label
    }()

    private lazy var togglePasswordButton: UIButton = {
        let button = UIButton()
        button.setImage(R.icon.eye, for: .normal)
        button.tintColor = R.color.gray70()
        button.frame = CGRect(x: 0, y: 0, width: 26, height: 16)

        button.addTarget(self, action: #selector(togglePasswordAction), for: .touchUpInside)

        return button
    }()

    // MARK: - Properties

    private(set) var errorState: ErrorState = .none

    var style: Style = .text {
        didSet {
            updateStyle(style)
        }
    }

    var placeholder: String {
        get { textField.placeholder ?? "" }
        set { textField.placeholder = newValue }
    }

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    weak var delegate: FormFieldViewDelegate?

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        addSubview(stackView)

        stackView.applyConstraints(.fit(in: self))
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(errorLabel)

        textField.applyConstraints(.height(constant: 46))

        setErrorState(errorState)
    }

    // MARK: - UI Methods

    private func updateStyle(_ style: Style) {
        textField.isSecureTextEntry = style.isSecure
        textField.keyboardType = style.keyboardType
        textField.autocorrectionType = style.autocorrectionType
        textField.autocapitalizationType = style.autocapitalizationType
        textField.clearButtonMode = style.isClearButtonVisible ? .whileEditing : .never
        textField.rightViewMode = style.hasShowPasswordButton ? .always : .never
    }

    func setErrorState(_ state: ErrorState) {
        errorLabel.text = state.errorText
        errorLabel.alpha = state.isLabelHidden ? 0 : 1
        errorLabel.isHidden = state.isLabelHidden

        textField.layer.borderWidth = state.fieldBorderWidth
        textField.layer.borderColor = state.fieldBorderColor.cgColor
    }

    // MARK: - UI Callbacks

    @objc private func togglePasswordAction() {
        textField.isSecureTextEntry.toggle()
        togglePasswordButton.setImage(
            textField.isSecureTextEntry ? R.icon.eye : R.icon.eyeSlashed,
            for: .normal
        )
    }
}

// MARK: - Definitions

extension FormFieldView {
    enum Style {
        case email, password, text

        var isSecure: Bool {
            return self == .password
        }

        var keyboardType: UIKeyboardType {
            return self == .email ? .emailAddress : .default
        }

        var autocorrectionType: UITextAutocorrectionType {
            return self == .text ? .default : .no
        }

        var autocapitalizationType: UITextAutocapitalizationType {
            return self == .text ? .sentences : .none
        }

        var isClearButtonVisible: Bool {
            return self != .password
        }

        var hasShowPasswordButton: Bool {
            return self == .password
        }
    }

    enum ErrorState {
        case errors([String]), none

        var errorText: String? {
            switch self {
            case let .errors(errors): return errors.joined(separator: "\n")
            case .none: return nil
            }
        }

        var isLabelHidden: Bool {
            switch self {
            case .none: return true
            case .errors: return false
            }
        }

        var fieldBorderWidth: CGFloat {
            switch self {
            case .none: return 0
            case .errors: return 1
            }
        }

        var fieldBorderColor: UIColor {
            switch self {
            case .none: return .clear
            case .errors: return R.color.brandError()!
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension FormFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.formFieldViewShouldReturn(self)
        return true
    }

    @objc private func textFieldDidChangeText(_ textField: UITextField) {
        delegate?.formFieldViewDidChangeText(self, newText: textField.text)
    }
}
