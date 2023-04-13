//
//  LessonDetailsViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 10.04.2023.
//

import Combine
import Foundation
import PKHUD
import UIKit

class LessonDetailsViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var headerView: LessonDetailsHeaderView = {
        let view = LessonDetailsHeaderView()
        return view
    }()

    private lazy var infoView: LessonDetailsInfoView = {
        let view = LessonDetailsInfoView()
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let button = SecondaryButton()
        button.tintColor = R.color.brandError()
        button.setTitle(Strings.myLessonsDetailsCancelButtonTitle(), for: .normal)
        button.addTarget(self, action: #selector(cancelLessonAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didCancelLesson: (() -> Void)?

    // MARK: - Properties

    private let viewModel: LessonDetailsViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: LessonDetailsViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadData()
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()

        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(infoView)
        contentView.addSubview(cancelButton)

        scrollView.applyConstraints(.fit(in: view.safeAreaLayoutGuide))

        contentView.applyConstraints(
            .fit(in: scrollView.contentLayoutGuide),
            .width(to: scrollView, attribute: .width),
            .height(
                to: scrollView.frameLayoutGuide,
                attribute: .height,
                equality: .greaterThanOrEqual
            )
        )

        headerView.applyConstraints(
            .leading(to: contentView, attribute: .leading),
            .trailing(to: contentView, attribute: .trailing),
            .top(to: contentView, attribute: .top)
        )

        infoView.applyConstraints(
            .leading(to: contentView, attribute: .leading),
            .trailing(to: contentView, attribute: .trailing),
            .top(to: headerView, attribute: .bottom)
        )

        cancelButton.applyConstraints(
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .top(to: infoView, attribute: .bottom, constant: 16, equality: .greaterThanOrEqual),
            .bottom(to: contentView, attribute: .bottom, constant: -16),
            .height(constant: 45)
        )
    }

    private func bindViewModelActions() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(
                    Strings.errorTitle(),
                    message: error.localizedDescription,
                    controller: self
                )
            }
            .store(in: &subscriptions)

        viewModel.$lessonInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                self?.configureViews(with: info)
            }
            .store(in: &subscriptions)

        viewModel.$cancelLessonEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.didCancelLesson?()
            }
            .store(in: &subscriptions)
    }

    func configureViews(with info: LessonDetailsViewModel.LessonInfo) {
        headerView.configureWith(
            model: .init(
                title: info.title,
                type: info.type,
                mentorName: info.mentorName,
                mentorAvatarUrl: info.mentorAvatarUrl
            )
        )

        infoView.configureWith(
            model: .init(
                description: info.description,
                contact: info.contact,
                time: info.time
            )
        )
    }

    // MARK: - UI Callbacks

    @objc private func cancelLessonAction() {
        viewModel.cancelLesson()
    }
}
