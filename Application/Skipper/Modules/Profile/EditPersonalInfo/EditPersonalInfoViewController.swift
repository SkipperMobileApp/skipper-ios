//
//  EditPersonalInfoViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.01.2023.
//

import Combine
import Foundation
import PKHUD
import TPKeyboardAvoiding
import UIKit

class EditPersonalInfoViewController: UIViewController {
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

    private lazy var personalHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.text = "Личные данные"
        label.numberOfLines = 1
        return label
    }()

    private lazy var firstNameTextField: SecondaryTextField = {
        let field = SecondaryTextField()
        field.placeholder = "Имя"
        return field
    }()

    private lazy var lastNameTextField: SecondaryTextField = {
        let field = SecondaryTextField()
        field.placeholder = "Фамилия"
        return field
    }()

    private lazy var emailHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.text = "Электронная почта"
        label.numberOfLines = 1
        return label
    }()

    private lazy var emailTextField: SecondaryTextField = {
        let field = SecondaryTextField()
        field.placeholder = "Электронная почта"
        field.isEnabled = false
        field.alpha = 0.5
        return field
    }()

    private lazy var postHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.text = "Специализация"
        label.numberOfLines = 1
        return label
    }()

    private lazy var postTextField: SecondaryTextField = {
        let field = SecondaryTextField()
        field.placeholder = "Специализация"
        return field
    }()

    private lazy var bioHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.text = "О себе"
        label.numberOfLines = 1
        return label
    }()

    private lazy var bioTextView: SecondaryTextView = {
        let view = SecondaryTextView()
        return view
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
    private let viewModel: EditPersonalInfoViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: EditPersonalInfoViewModel) {
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

        viewModel.loadData()
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()
        title = "Изменить данные"
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(personalHeaderLabel)
        containerView.addSubview(firstNameTextField)
        containerView.addSubview(lastNameTextField)
        containerView.addSubview(emailHeaderLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(postHeaderLabel)
        containerView.addSubview(postTextField)
        containerView.addSubview(bioHeaderLabel)
        containerView.addSubview(bioTextView)
        containerView.addSubview(saveButton)

        scrollView.applyConstraints(.fit(in: view.safeAreaLayoutGuide))
        containerView.applyConstraints(
            .fit(in: scrollView.contentLayoutGuide),
            .width(to: scrollView, attribute: .width),
            .height(to: scrollView, attribute: .height, equality: .greaterThanOrEqual)
        )

        personalHeaderLabel.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16)
        )

        firstNameTextField.applyConstraints(
            .top(to: personalHeaderLabel, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .height(constant: 45)
        )

        lastNameTextField.applyConstraints(
            .top(to: firstNameTextField, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .height(constant: 45)
        )

        emailHeaderLabel.applyConstraints(
            .top(to: lastNameTextField, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16)
        )

        emailTextField.applyConstraints(
            .top(to: emailHeaderLabel, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .height(constant: 45)
        )

        postHeaderLabel.applyConstraints(
            .top(to: emailTextField, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16)
        )

        postTextField.applyConstraints(
            .top(to: postHeaderLabel, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .height(constant: 45)
        )

        bioHeaderLabel.applyConstraints(
            .top(to: postTextField, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16)
        )

        bioTextView.applyConstraints(
            .top(to: bioHeaderLabel, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .height(constant: 250)
        )

        saveButton.applyConstraints(
            .top(to: bioTextView, attribute: .bottom, constant: 16, equality: .greaterThanOrEqual),
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
                    "Данные сохранены",
                    message: "Данные успешно сохранены!",
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

        viewModel.$personalInfoEvent
            .sink { [weak self] info in
                self?.firstNameTextField.text = info.firstName
                self?.lastNameTextField.text = info.lastName
                self?.emailTextField.text = info.email
                self?.postTextField.text = info.post
                self?.bioTextView.text = info.bio
            }
            .store(in: &subscriptions)
    }

    // MARK: - UI Callbacks

    @objc private func saveAction() {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let post = postTextField.text ?? ""
        let bio = bioTextView.text ?? ""

        viewModel.save(
            firstName: firstName,
            lastName: lastName,
            email: email,
            post: post,
            bio: bio
        )
    }
}
