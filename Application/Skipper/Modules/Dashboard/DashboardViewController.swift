//
//  DashboardViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Combine
import FirebaseAnalytics
import Foundation
import PKHUD
import UIKit

class DashboardViewController: UIViewController {
    // MARK: - Definitions

    typealias Section = DashboardViewModel.Section

    // MARK: - UI Controls

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeLayout()
        )

        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(cellType: DashboardCategoryCollectionCell.self)
        collectionView.register(cellType: DashboardMentorCollectionCell.self)
        collectionView.register(
            supplementaryViewType: DashboardSectionHeaderView.self,
            ofKind: UICollectionView.elementKindSectionHeader
        )
        collectionView.register(
            supplementaryViewType: DashboardCategoryFooterView.self,
            ofKind: UICollectionView.elementKindSectionFooter
        )

        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didTapCategory: ((_ categoryId: String) -> Void)?
    var didTapMentor: ((_ mentorId: String) -> Void)?

    // MARK: - Properties

    private let viewModel: DashboardViewModel
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: DashboardViewModel) {
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

        Analytics.logEvent("main_Screen_Shown", parameters: nil)
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()
        title = Strings.dashboardNavTitle()
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .always

        view.addSubview(collectionView)
        collectionView
            .applyConstraints(.fitWithInsets(
                in: view,
                insets: .init(top: 0, left: 8, bottom: 0, right: 8)
            ))
        collectionView.clipsToBounds = false
    }

    private func bindViewModelActions() {
        viewModel.$loadDataEvent
            .sink { [weak self] in
                self?.reloadData()
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

        viewModel.$isLoading
            .sink { isLoading in
                isLoading ? HUD.show(.progress) : HUD.hide()
            }
            .store(in: &subscriptions)
    }

    private func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - Collection View

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func makeLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 25

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
                guard let self = self else { return nil }

                let section = self.viewModel.sections[sectionIndex]

                switch section {
                case .categories: return self.makeCategorySectionLayout()
                case .popularMentors: return self.makeMentorsSectionLayout()
                }
            },
            configuration: config
        )

        return layout
    }

    private func makeCategorySectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)

        let innerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let innerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: innerGroupSize,
            subitems: [item]
        )

        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitems: [innerGroup]
        )

        let outerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(280)
        )
        let outerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: outerGroupSize,
            subitems: [verticalGroup]
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            containerAnchor: .init(edges: .top)
        )

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            containerAnchor: .init(edges: .bottom)
        )

        let section = NSCollectionLayoutSection(group: outerGroup)
        section.boundarySupplementaryItems = [header, footer]
        section.orthogonalScrollingBehavior = .groupPaging
        section.supplementariesFollowContentInsets = false
        section.contentInsets = .init(top: 35, leading: 0, bottom: 30, trailing: 0)
        section.visibleItemsInvalidationHandler = { [weak self] _, offset, _ in
            guard let self = self else { return }

            let page = Int(round(offset.x / (self.view.bounds.width - 16)))
            self.viewModel.setCategoriesCurrentPage(page)
        }
        return section
    }

    private func makeMentorsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalWidth(0.5)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            containerAnchor: .init(edges: .top)
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .groupPaging
        section.supplementariesFollowContentInsets = false
        section.contentInsets = .init(top: 35, leading: 0, bottom: 10, trailing: 0)

        return section
    }

    /// UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch viewModel.sections[section] {
        case let .categories(items): return items.count
        case let .popularMentors(items): return items.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let section = viewModel.sections[indexPath.section]

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view: DashboardSectionHeaderView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)

            view.title = section.title
            return view

        case UICollectionView.elementKindSectionFooter:
            if case let .categories(items) = section {
                let view: DashboardCategoryFooterView = collectionView
                    .dequeueReusableSupplementaryView(
                        ofKind: kind,
                        for: indexPath
                    )

                view.configureWith(
                    numberOfPages: Int(ceil(Double(items.count) / 6.0)),
                    currentPagePublisher: viewModel.$categoriesPage.eraseToAnyPublisher()
                )
                return view
            }

        default:
            break
        }

        return UICollectionReusableView()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = viewModel.sections[indexPath.section]

        switch section {
        case let .categories(items):
            let cell: DashboardCategoryCollectionCell = collectionView
                .dequeueReusableCell(for: indexPath)
            let item = items[indexPath.item]
            cell.configureWith(image: item.image, title: item.title)
            return cell

        case let .popularMentors(items):
            let cell: DashboardMentorCollectionCell = collectionView
                .dequeueReusableCell(for: indexPath)
            let item = items[indexPath.item]
            cell.configureWith(
                name: item.name,
                major: item.major,
                likesCount: item.likesCount,
                imageUrl: item.imageUrl
            )
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]

        switch section {
        case let .categories(items):
            didTapCategory?(items[indexPath.item].id)
            Analytics.logEvent(
                "main_Screen_Categories_Tap",
                parameters: ["categoryName": items[indexPath.item].title]
            )
        case let .popularMentors(items):
            didTapMentor?(items[indexPath.row].id)
            Analytics.logEvent(
                "main_Screen_Mentors_Tap",
                parameters: ["mentorId": items[indexPath.item].id]
            )
        }
    }
}
