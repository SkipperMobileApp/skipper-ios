//
//  MentorProfileViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2023.
//

import Combine
import Foundation
import PKHUD
import UIKit

class MentorProfileViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 24
        return stackView
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = R.color.primary24()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.header
        label.textColor = R.color.primary87()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private lazy var majorLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.body
        label.textColor = R.color.primary54()
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.body
        label.textColor = R.color.primary54()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var statusView: StatusView = {
        let view = StatusView()
        return view
    }()

    private lazy var skillsCloudView: CloudView = {
        let view = CloudView()
        return view
    }()

    private lazy var classesView: MentorProfileClassesView = {
        let view = MentorProfileClassesView()

        view.didSelectItemAtIndex = { [weak self] index in
            guard let self = self else { return }
            let item = self.viewModel.classItems[index]
            self.didSelectLesson?(item.id)
        }

        return view
    }()

    private lazy var resumeView: MentorProfileResumeView = {
        let view = MentorProfileResumeView()
        return view
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSelectLesson: ((_ id: String) -> Void)?
    var didTapClassesList: (() -> Void)?

    // MARK: - Properties

    private let viewModel: MentorProfileViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: MentorProfileViewModel) {
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

        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(stackView)

        scrollView.applyConstraints(.fit(in: view))

        containerView.applyConstraints(
            .fit(in: scrollView.contentLayoutGuide),
            .width(to: scrollView, attribute: .width)
        )

        stackView.applyConstraints(
            .fitWithInsets(
                in: containerView,
                insets: .init(top: 24, left: 16, bottom: 24, right: 16)
            )
        )

        setupStack()
    }

    private func setupStack() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let avatarView = UIView()
        avatarView.addSubview(avatarImageView)
        avatarImageView.applyConstraints(
            .width(constant: 80),
            .height(constant: 80),
            .top(to: avatarView, attribute: .top),
            .bottom(to: avatarView, attribute: .bottom),
            .centerX(to: avatarView, attribute: .centerX)
        )

        stackView.addArrangedSubview(avatarView)
        stackView.setCustomSpacing(16, after: avatarView)

        stackView.addArrangedSubview(nameLabel)
        stackView.setCustomSpacing(8, after: nameLabel)

        stackView.addArrangedSubview(majorLabel)
        stackView.setCustomSpacing(16, after: majorLabel)

        stackView.addArrangedSubview(descriptionLabel)
        stackView.setCustomSpacing(24, after: descriptionLabel)

        stackView.addArrangedSubview(statusView)
        stackView.setCustomSpacing(24, after: statusView)

        let skillsHeader = makeHeader(with: "Компетенции")
        stackView.addArrangedSubview(skillsHeader)
        stackView.setCustomSpacing(8, after: skillsHeader)

        stackView.addArrangedSubview(skillsCloudView)
        stackView.setCustomSpacing(24, after: skillsCloudView)

        let classesHeader = makeHeader(with: "Занятия")
        stackView.addArrangedSubview(classesHeader)
        stackView.setCustomSpacing(8, after: classesHeader)

        classesHeader.buttonTitle = viewModel.classItems.count > 3 ? "Все" : ""
        classesHeader.isButtonHidden = viewModel.classItems.count < 4
        classesHeader.didTapButton = { [weak self] in
            self?.didTapClassesList?()
        }

        stackView.addArrangedSubview(classesView)
        stackView.setCustomSpacing(24, after: classesView)

        let resumeHeader = makeHeader(with: "Резюме")
        stackView.addArrangedSubview(resumeHeader)
        stackView.setCustomSpacing(8, after: resumeHeader)

        stackView.addArrangedSubview(resumeView)
        stackView.setCustomSpacing(24, after: resumeHeader)

        stackView.layoutIfNeeded()
        classesView.reloadData()
    }

    private func updateData() {
        title = viewModel.title

        // General info

        nameLabel.text = viewModel.profileInfo.name
        majorLabel.text = viewModel.profileInfo.major
        descriptionLabel.text = viewModel.profileInfo.description
        avatarImageView.kf.setImage(
            with: URL(string: viewModel.profileInfo.imageUrl ?? ""),
            placeholder: nil
        )

        // Status info

        statusView.configure(with: viewModel.statusItems.map {
            .init(title: $0.title, subtitle: $0.subtitle)
        })

        // Classes

        classesView.configureWith(items: viewModel.classItems.map {
            .init(title: $0.title, description: $0.description)
        })

        // Skills

        let skillItems = viewModel.skills.map {
            let label = TextCloudItem()
            label.text = $0
            label.backgroundColor = R.color.brandPrimary()!
            label.font = R.typo.body
            label.textColor = R.color.secondary100()!
            return label
        }

        let attributes = CloudView.Layout.Attributes(
            insets: .zero,
            rowSpace: 8,
            itemSpace: 8,
            itemHeight: 30,
            alignment: .left
        )
        let layout = CloudView.calculateLayout(
            for: skillItems,
            attributes: attributes,
            width: view.frame.width - 32
        )
        skillsCloudView.updateWith(skillItems, layout: layout)

        // Resume

        resumeView.configureWith(items: viewModel.resumeItems.map {
            let items: [MentorProfileResumeView.ViewModel.Item]
            switch $0 {
            case let .education(educationItems):
                items = educationItems.map {
                    .init(
                        title: "\($0.startYear)-\($0.endYear), \($0.name)",
                        subtitle: $0.degree
                    )
                }
            case let .work(workItems):
                items = workItems.map {
                    .init(
                        title: "\($0.startYear)-\($0.endYear.flatMap(String.init) ?? "н.в."), \($0.name)",
                        subtitle: $0.post
                    )
                }
            case let .achievements(achievementItems):
                items = achievementItems.map {
                    .init(
                        title: "\($0.year), \($0.name)",
                        subtitle: $0.info
                    )
                }
            }

            return .init(title: $0.title, image: $0.icon, items: items)
        })
    }

    private func bindViewModelActions() {
        viewModel.$loadDataEvent
            .sink { [weak self] in
                self?.updateData()
            }
            .store(in: &subscriptions)

        viewModel.$isLoading
            .sink { isLoading in
                isLoading ? HUD.show(.progress) : HUD.hide()
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

    // MARK: - UI Builders

    private func makeHeader(with text: String) -> MentorProfileHeaderView {
        let view = MentorProfileHeaderView()
        view.title = text
        return view
    }
}
