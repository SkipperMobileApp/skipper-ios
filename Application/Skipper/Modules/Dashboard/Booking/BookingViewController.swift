//
//  BookingViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Combine
import Foundation
import PKHUD
import UIKit

class BookingViewController: UIViewController {
    // MARK: - Output

    var didFinish: (() -> Void)?
    var didFinishBooking: (() -> Void)?

    // MARK: - Properties

    private let viewModel: BookingViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: BookingViewModel) {
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

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""

        let controller = BookingPageViewController(viewModel: viewModel)

        controller.didPrepareForBooking = { [weak self] in
            self?.save()
        }

        view.addSubview(controller.view)
        controller.view.applyConstraints(.fit(in: view.safeAreaLayoutGuide))

        addChild(controller)
        controller.didMove(toParent: self)
    }

    private func bindViewModelActions() {
        viewModel.$isLoading
            .sink { isLoading in
                isLoading ? HUD.show(.progress) : HUD.hide()
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(error.localizedDescription,
                                                  controller: self)
            }
            .store(in: &subscriptions)

        viewModel.$bookClassEvent
            .sink { [weak self] in
                self?.didFinishBooking?()
            }
            .store(in: &subscriptions)
    }

    private func save() {
        let validationResults = viewModel.validateValues()

        guard validationResults.isEmpty else {
            AlertPresenter.presentSimpleAlert(validationResults.joined(separator: "\n"),
                                              controller: self)
            return
        }

        viewModel.bookClass()
    }
}
