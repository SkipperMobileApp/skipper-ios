//
//  BookingPageViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation
import UIKit

class BookingPageViewController: UIPageViewController {
    // MARK: - Definitions

    typealias Step = BookingViewModel.Step

    // MARK: - UI Controls

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = R.color.brandPrimary()
        pageControl.pageIndicatorTintColor = R.color.primary24()
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didPrepareForBooking: (() -> Void)?

    // MARK: - Properties

    private let viewModel: BookingViewModel

    private var stepControllers: [Step: UIViewController] = [:]

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: BookingViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
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

        navigateTo(step: .type)
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""

        delegate = self
        dataSource = self

        initializeControllers()

        pageControl.numberOfPages = stepControllers.keys.count

        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)

        pageControl.applyConstraints(
            .centerX(to: view, attribute: .centerX),
            .bottom(to: view, attribute: .bottom, constant: -16)
        )
    }

    private func bindViewModelActions() {}

    private func initializeControllers() {
        let typeController = BookingTypeViewController(viewModel: viewModel.typeViewModel)

        typeController.didTapNext = { [weak self] in
            Step.type.nextStep.flatMap { self?.navigateTo(step: $0) }
        }

        let amountController = BookingAmountViewController(viewModel: viewModel.amountViewModel)

        amountController.didTapNext = { [weak self] in
            Step.amount.nextStep.flatMap { self?.navigateTo(step: $0) }
        }

        let timeController = BookingTimeViewController(viewModel: viewModel.timeViewModel)

        timeController.didTapNext = { [weak self] in
            Step.time.nextStep.flatMap { self?.navigateTo(step: $0) }
        }

        let contactController = BookingContactViewController(viewModel: viewModel.contactViewModel)

        contactController.didTapBook = { [weak self] in
            self?.didPrepareForBooking?()
        }

        stepControllers = [
            .type: typeController,
            .amount: amountController,
            .time: timeController,
            .contact: contactController
        ]
    }

    private func navigateTo(step: Step) {
        guard let controller = stepControllers[step] else { return }

        setViewControllers([controller], direction: .forward, animated: true)

        pageControl.currentPage = Step.allCases.firstIndex(of: step) ?? 0
    }
}

// MARK: - UIPageViewControllerDelegate

extension BookingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let step = stepControllers.first(where: { $0.value == pendingViewControllers[0] })?.key,
              let stepIndex = Step.allCases.firstIndex(of: step)
        else { return }

        pageControl.currentPage = stepIndex
    }
}

// MARK: - UIPageViewControllerDataSource

extension BookingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let step = stepControllers.first(where: { $0.value == viewController })?.key else { return nil }
        return step.nextStep.flatMap { stepControllers[$0] }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let step = stepControllers.first(where: { $0.value == viewController })?.key else { return nil }
        return step.previousStep.flatMap { stepControllers[$0] }
    }
}
