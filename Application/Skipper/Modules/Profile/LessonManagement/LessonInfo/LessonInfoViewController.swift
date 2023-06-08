//
//  LessonInfoViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 17.04.2023.
//

import Combine
import Foundation
import PKHUD
import TPKeyboardAvoiding
import UIKit

class LessonInfoViewController: UIViewController {
    // MARK: - Definitions

    typealias Field = LessonInfoViewModel.Field

    // MARK: - UI Controls

    private lazy var scrollView: UIScrollView = {
        let scrollView = TPKeyboardAvoidingScrollView()
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    private var textFields: [Field: UITextField] = [:]
    private var textViews: [Field: UITextView] = [:]
    private var optionViews: [Field: LessonInfoOptionView] = [:]
    private var timeView: LessonInfoTimeView?

    private lazy var pickerPresenter: PickerPresenter = {
        let presenter = PickerPresenter()
        presenter.timeSlotsDelegate = self
        return presenter
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSaveLesson: (() -> Void)?

    // MARK: - Properties

    private var selectedTimeIndex: Int?

    private let viewModel: LessonInfoViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: LessonInfoViewModel) {
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

        title = viewModel.isNewLesson ? "Добавить занятие" : "Изменить занятие"
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(stackView)

        scrollView.applyConstraints(.fit(in: view.safeAreaLayoutGuide))

        containerView.applyConstraints(
            .fit(in: scrollView.contentLayoutGuide),
            .width(to: scrollView, attribute: .width)
        )

        stackView.applyConstraints(
            .fitWithInsets(
                in: containerView,
                insets: .init(top: 16, left: 16, bottom: 16, right: 16)
            )
        )

        setupStackView(with: nil)
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

        viewModel.$saveLessonEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.didSaveLesson?()
            }
            .store(in: &subscriptions)

        viewModel.$loadLessonEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lessonInfo in
                self?.setupStackView(with: lessonInfo)
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

        viewModel.$wasDataChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wasDataChanged in
                self?.updateNavBar(wasDataChanged)
            }
            .store(in: &subscriptions)
    }

    private func updateNavBar(_ isSaveEnabled: Bool) {
        guard isSaveEnabled else {
            navigationItem.rightBarButtonItem = nil
            return
        }

        let saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(saveLessonAction)
        )
        saveButton.tintColor = R.color.brandPrimary()
        navigationItem.rightBarButtonItem = saveButton
    }

    private func setupStackView(with lessonInfo: LessonInfoViewModel.LessonInfo?) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        textFields = [:]
        textViews = [:]
        optionViews = [:]
        timeView = nil

        let name = lessonInfo?.name
        let description = lessonInfo?.description
        let typeItems: [LessonInfoOptionView.Option] = LessonInfoViewModel.LessonType.allCases.map {
            .init(text: $0.title, isChecked: lessonInfo?.types.contains($0) ?? false)
        }
        let durationItems: [LessonInfoOptionView.Option] = LessonInfoViewModel.LessonDuration
            .allCases.map {
                .init(text: $0.title, isChecked: lessonInfo?.durations.contains($0) ?? false)
            }
        let timePeriodItems: [LessonInfoTimeView.TimeItem] = lessonInfo?.timePeriods
            .sorted {
                $0.weekday.rawValue < $1.weekday.rawValue
            }
            .map {
                .init(day: $0.weekday.title, time: $0.slot.fullTime)
            } ?? []

        let nameField = makeTextField(for: .name, with: name)
        stackView.addArrangedSubview(makeHeaderView(with: Field.name.headerTitle))
        stackView.addArrangedSubview(nameField)
        textFields[.name] = nameField

        let descriptionView = makeTextView(for: .description, with: description)
        stackView.addArrangedSubview(makeHeaderView(with: Field.description.headerTitle))
        stackView.addArrangedSubview(descriptionView)
        textViews[.description] = descriptionView

        if let typeView = makeOptionView(for: .type, with: typeItems) {
            stackView.addArrangedSubview(makeHeaderView(with: Field.type.headerTitle))
            stackView.addArrangedSubview(typeView)
            optionViews[.type] = typeView
        }

        if let durationView = makeOptionView(for: .duration, with: durationItems) {
            stackView.addArrangedSubview(makeHeaderView(with: Field.duration.headerTitle))
            stackView.addArrangedSubview(durationView)
            optionViews[.duration] = durationView
        }

        let timeView = makeTimeView(with: timePeriodItems)
        stackView.addArrangedSubview(makeHeaderView(with: Field.time.headerTitle))
        stackView.addArrangedSubview(timeView)
        self.timeView = timeView
    }

    private func presentTimeSlotsPicker() {
        let periods = viewModel.retrieveFreeTimePeriods()
        pickerPresenter.presentTimeSlotsPicker(
            pickerData: .init(
                title: "Выберите дату и время",
                selectedDateIndex: nil,
                selectedTimeIndex: nil,
                items: periods
                    .map { .init(date: $0.day.title, slots: $0.slots.map { $0.fullTime }) }
            )
        )
    }

    // MARK: - UI Builders

    private func makeHeaderView(with text: String) -> UIView {
        let view = UIView()

        let label = UILabel()
        label.text = text
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1

        view.addSubview(label)

        label.applyConstraints(.fit(in: view))

        return view
    }

    private func makeTextField(for field: Field, with text: String?) -> UITextField {
        let textField = SecondaryTextField()

        textField.text = text
        textField.placeholder = field.placeholder
        textField.autocapitalizationType = .sentences
        textField.autocorrectionType = .no

        textField.applyConstraints(.height(constant: 44))

        textField.addTarget(self, action: #selector(textFieldChangedAction), for: .editingChanged)

        return textField
    }

    private func makeTextView(for field: Field, with text: String?) -> UITextView {
        let textView = SecondaryTextView()
        textView.delegate = self
        textView.text = text
        textView.applyConstraints(.height(constant: 200))

        return textView
    }

    private func makeOptionView(
        for field: Field,
        with items: [LessonInfoOptionView.Option]
    ) -> LessonInfoOptionView? {
        let view = LessonInfoOptionView()

        switch field {
        case .type:
            let types = LessonInfoViewModel.LessonType.allCases
            view.configure(with: items)

            view.didSelectOption = { [weak self] index in
                self?.viewModel.setLessonType(types[index], isSelected: true)
            }

            view.didDeselectOption = { [weak self] index in
                self?.viewModel.setLessonType(types[index], isSelected: false)
            }

        case .duration:
            let durations = LessonInfoViewModel.LessonDuration.allCases

            view.configure(with: items)

            view.didSelectOption = { [weak self] index in
                self?.viewModel.setLessonDuration(durations[index], isSelected: true)
            }

            view.didDeselectOption = { [weak self] index in
                self?.viewModel.setLessonDuration(durations[index], isSelected: false)
            }
        default:
            return nil
        }

        return view
    }

    private func makeTimeView(with items: [LessonInfoTimeView.TimeItem]) -> LessonInfoTimeView {
        let view = LessonInfoTimeView()
        view.configure(with: items)

        view.didDeleteTime = { [weak self] index in
            self?.viewModel.freeTimePeriod(at: index)
            view.deleteItem(at: index)
        }

        view.didSelectTime = { [weak self] index in
            self?.selectedTimeIndex = index
            self?.presentTimeSlotsPicker()
        }

        view.didAddTime = { [weak view] in
            view?.addItem()
        }

        return view
    }

    // MARK: - UI Callbacks

    @objc private func saveLessonAction() {
        if let validationResult = viewModel.validateData() {
            AlertPresenter.presentSimpleAlert(
                R.string.localizable.errorTitle(),
                message: validationResult,
                controller: self
            )
            return
        }

        viewModel.saveLesson()
    }

    @objc private func textFieldChangedAction(_ textField: UITextField) {
        if textFields[.name] === textField {
            viewModel.setLessonName(textField.text ?? "")
        }
    }
}

// MARK: - UITextViewDelegate

extension LessonInfoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textViews[.description] === textView {
            viewModel.setLessonDescription(textView.text)
        }
    }
}

// MARK: - TimeSlotsPickerDelegate

extension LessonInfoViewController: TimeSlotsPickerDelegate {
    func timeSlotsPicker(
        _ presenter: PickerPresenter,
        didSelectDateIndex dateIndex: Int,
        withTimeIndex timeIndex: Int
    ) {
        guard let selectedTimeIndex else { return }

        let freeSlots = viewModel.retrieveFreeTimePeriods()

        let weekday = freeSlots[dateIndex].day
        let slot = freeSlots[dateIndex].slots[timeIndex]
        let period = LessonInfoViewModel.TimePeriod(weekday: weekday, slot: slot)

        viewModel.bookTimePeriod(period, replacingIndex: selectedTimeIndex)

        timeView?.updateItem(
            at: selectedTimeIndex,
            with: .init(day: weekday.title, time: slot.fullTime)
        )

        pickerPresenter.dismiss()
    }
}
