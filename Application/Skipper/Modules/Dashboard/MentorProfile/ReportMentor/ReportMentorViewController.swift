//
//  ReportMentorViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.06.2023.
//

import Combine
import Foundation
import PKHUD
import UIKit

class ReportMentorViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var typeHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория жалобы"
        label.font = R.typo.header
        label.textColor = R.color.primary87()
        return label
    }()

    private lazy var typeDropdownButton: DropdownButton = {
        let button = DropdownButton()
        button.placeholder = "Выберите категорию жалобы"
        button.addTarget(self, action: #selector(selectTypeAction), for: .touchUpInside)
        return button
    }()

    private lazy var textHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание проблемы"
        label.font = R.typo.header
        label.textColor = R.color.primary87()
        return label
    }()

    private lazy var textView: SecondaryTextView = {
        let textView = SecondaryTextView()
        return textView
    }()

    private lazy var sendButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle("Отправить жалобу", for: .normal)
        button.addTarget(self, action: #selector(sendReportAction), for: .touchUpInside)
        return button
    }()

    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()

        let navItem = UINavigationItem()

        let closeButton = UIBarButtonItem(
            image: R.icon.cross,
            style: .plain,
            target: self,
            action: #selector(closeAction)
        )
        closeButton.tintColor = R.color.primary54()

        navItem.rightBarButtonItem = closeButton
        navItem.backBarButtonItem = nil

        navBar.items = [navItem]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navBar.standardAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactScrollEdgeAppearance = appearance

        return navBar
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSendReport: (() -> Void)?
    var didTapClose: (() -> Void)?

    // MARK: - Properties

    private let viewModel: ReportMentorViewModel

    private var subscriptions = Set<AnyCancellable>()

    private lazy var pickerPresenter: PickerPresenter = {
        let presenter = PickerPresenter()
        presenter.itemDelegate = self
        return presenter
    }()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: ReportMentorViewModel) {
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

        view.addSubview(navigationBar)
        view.addSubview(typeHeaderLabel)
        view.addSubview(typeDropdownButton)
        view.addSubview(textHeaderLabel)
        view.addSubview(textView)
        view.addSubview(sendButton)

        navigationBar.applyConstraints(
            .top(to: view.safeAreaLayoutGuide, attribute: .top),
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing),
            .height(constant: 50)
        )

        typeHeaderLabel.applyConstraints(
            .top(to: navigationBar, attribute: .bottom, constant: 16),
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading, constant: 16),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing, constant: -16)
        )

        typeDropdownButton.applyConstraints(
            .top(to: typeHeaderLabel, attribute: .bottom, constant: 8),
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading, constant: 16),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing, constant: -16),
            .height(constant: 45)
        )

        textHeaderLabel.applyConstraints(
            .top(to: typeDropdownButton, attribute: .bottom, constant: 16),
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading, constant: 16),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing, constant: -16)
        )

        textView.applyConstraints(
            .top(to: textHeaderLabel, attribute: .bottom, constant: 8),
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading, constant: 16),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing, constant: -16),
            .height(constant: 350, equality: .greaterThanOrEqual),
            .bottom(to: sendButton, attribute: .top, constant: -16, equality: .lessThanOrEqual)
        )

        sendButton.applyConstraints(
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading, constant: 16),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing, constant: -16),
            .bottom(to: view.safeAreaLayoutGuide, attribute: .bottom, constant: -16),
            .height(constant: 45)
        )
    }

    private func bindViewModelActions() {
        viewModel.$mentorName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.navigationBar.topItem?.title = name.flatMap { "Пожаловаться на \($0)" }
            }
            .store(in: &subscriptions)

        viewModel.$sendReportEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }

                AlertPresenter.presentSimpleAlert(
                    "Отлично!",
                    message: "Ваше обращение было зафиксировано и будет рассмотрено в ближайшее время!",
                    controller: self
                ) { [weak self] in
                    self?.didSendReport?()
                }
            }
            .store(in: &subscriptions)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                isLoading ? HUD.show(.progress) : HUD.hide()
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(
                    "Ошибка",
                    message: error.localizedDescription,
                    controller: self
                )
            }
            .store(in: &subscriptions)

        viewModel.$selectedTypeIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }

                self.typeDropdownButton.text = index
                    .flatMap { self.viewModel.reportTypes[$0].title }
            }
            .store(in: &subscriptions)
    }

    private func sendReport() {
        let text = textView.text ?? ""

        if let validationError = viewModel.validate(text: text) {
            AlertPresenter.presentSimpleAlert(
                "Ошибка",
                message: validationError,
                controller: self
            )
            return
        }

        viewModel.sendReport(text: text)
    }

    // MARK: - UI Callbacks

    @objc private func selectTypeAction() {
        pickerPresenter.presentItemPicker(
            pickerData: .init(
                title: "Выберите категорию",
                items: viewModel.reportTypes.map(\.title),
                selectedIndex: viewModel.selectedTypeIndex
            ),
            on: self
        )
    }

    @objc private func sendReportAction() {
        sendReport()
    }

    @objc private func closeAction() {
        didTapClose?()
    }
}

extension ReportMentorViewController: ItemPickerDelegate {
    func itemPicker(_ presenter: PickerPresenter, didSelectItemAtIndex index: Int) {
        viewModel.selectType(at: index)

        presenter.dismiss()
    }
}
