//
//  ChangePasswordViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.01.2023.
//

import Combine
import Foundation
import PKHUD
import TPKeyboardAvoiding
import UIKit

class ChangePasswordViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var scrollView: UIScrollView = {
        let scrollView = TPKeyboardAvoidingScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var oldPasswordHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.text = "Старый пароль"
        label.numberOfLines = 1
        return label
    }()

    private lazy var oldPasswordTextField: PasswordSecondaryTextField = {
        let field = PasswordSecondaryTextField()
        field.placeholder = "Старый пароль"
        return field
    }()

    private lazy var newPasswordHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.text = "Новый пароль"
        label.numberOfLines = 1
        return label
    }()

    private lazy var newPasswordTextField: PasswordSecondaryTextField = {
        let field = PasswordSecondaryTextField()
        field.placeholder = "Новый пароль"
        return field
    }()

    private lazy var saveButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSaveData: (() -> Void)?

    // MARK: - Properties

    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: ChangePasswordViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        bindViewModelActions()
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()
        title = "Изменить данные"
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(oldPasswordHeaderLabel)
        containerView.addSubview(oldPasswordTextField)
        containerView.addSubview(newPasswordHeaderLabel)
        containerView.addSubview(newPasswordTextField)
        containerView.addSubview(saveButton)

        scrollView.applyConstraints(.fit(in: view.safeAreaLayoutGuide))
        containerView.applyConstraints(
            .fit(in: scrollView.contentLayoutGuide),
            .width(to: scrollView, attribute: .width),
            .height(to: scrollView, attribute: .height, equality: .greaterThanOrEqual)
        )

        oldPasswordHeaderLabel.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16)
        )

        oldPasswordTextField.applyConstraints(
            .top(to: oldPasswordHeaderLabel, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .height(constant: 45)
        )

        newPasswordHeaderLabel.applyConstraints(
            .top(to: oldPasswordTextField, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16)
        )

        newPasswordTextField.applyConstraints(
            .top(to: newPasswordHeaderLabel, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .height(constant: 45)
        )

        saveButton.applyConstraints(
            .top(to: newPasswordTextField, attribute: .bottom, constant: 16, equality: .greaterThanOrEqual),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .bottom(to: containerView, attribute: .bottom, constant: -16),
            .height(constant: 45)
        )
    }

    private func bindViewModelActions() {
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            }
            .store(in: &subscriptions)

        viewModel.$saveDataEvent
            .sink { [weak self] in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(
                    "Пароль сохранен",
                    message: "Пароль успешно сохранен!",
                    controller: self
                )
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(
                    "Ошибка",
                    message: error.localizedDescription,
                    controller: self
                )
            }
            .store(in: &subscriptions)
    }

    // MARK: - UI Callbacks

    @objc private func saveAction() {
        let oldPassword = oldPasswordTextField.text ?? ""
        let newPassword = newPasswordTextField.text ?? ""

        viewModel.save(oldPassword: oldPassword, newPassword: newPassword)
    }
}
