//
//  TimeSlotsPickerViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 21.05.2023.
//

import Foundation
import UIKit

class TimeSlotsPickerViewController: UIViewController {
    struct PickerData {
        let title: String
        let selectedStartTime: Date?
        let selectedEndTime: Date?
    }

    private enum PickerComponent: Int, CaseIterable {
        case startTime = 0
        case endTime = 1
    }

    // MARK: - UI Controls

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)

        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        gesture.addTarget(self, action: #selector(tapAction))
        gesture.delegate = self

        view.addGestureRecognizer(gesture)
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.themePrimary()
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 2
        return label
    }()

    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()

    private lazy var cancelButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Отмена", for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()

    private lazy var selectButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Выбрать", for: .normal)
        button.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Output

    var didTapCancel: (() -> Void)?
    var didSelectTimeSlot: ((_ startDate: Date, _ endDate: Date) -> Void)?

    // MARK: - Properties

    private lazy var allSlots: [Date] = stride(from: 0, to: 86400, by: 900).map {
        Date(timeIntervalSince1970: $0)
    }

    // MARK: - Initialization

    init(pickerData: PickerData) {
        super.init(nibName: nil, bundle: nil)

        pickerView.selectRow(
            pickerData.selectedStartTime.flatMap(allSlots.firstIndex) ?? 0,
            inComponent: PickerComponent.startTime.rawValue,
            animated: false
        )

        pickerView.selectRow(
            pickerData.selectedEndTime.flatMap(allSlots.firstIndex) ?? 0,
            inComponent: PickerComponent.endTime.rawValue,
            animated: false
        )

        titleLabel.text = pickerData.title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(pickerView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(selectButton)

        backgroundView.applyConstraints(.fit(in: view))

        contentView.applyConstraints(
            .centerY(to: backgroundView, attribute: .centerY),
            .leading(to: backgroundView, attribute: .leading, constant: 32),
            .trailing(to: backgroundView, attribute: .trailing, constant: -32)
        )

        titleLabel.applyConstraints(
            .top(to: contentView, attribute: .top, constant: 16),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: contentView, attribute: .trailing, constant: -16)
        )

        pickerView.applyConstraints(
            .top(to: titleLabel, attribute: .bottom, constant: 16),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .height(constant: 150)
        )

        cancelButton.applyConstraints(
            .top(to: pickerView, attribute: .bottom, constant: 16),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: contentView, attribute: .centerX, constant: -8),
            .bottom(to: contentView, attribute: .bottom, constant: -16),
            .height(constant: 40)
        )

        selectButton.applyConstraints(
            .leading(to: contentView, attribute: .centerX, constant: 8),
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .height(constant: 40),
            .centerY(to: cancelButton, attribute: .centerY)
        )
    }

    // MARK: - Data Source

    private func updateTimeSlots() {}

    // MARK: - UI Callbacks

    @objc private func cancelAction() {
        didTapCancel?()
    }

    @objc private func selectAction() {
        didSelectTimeSlot?(
            allSlots[pickerView.selectedRow(inComponent: PickerComponent.startTime.rawValue)],
            allSlots[pickerView.selectedRow(inComponent: PickerComponent.endTime.rawValue)]
        )
    }

    @objc private func tapAction() {
        didTapCancel?()
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension TimeSlotsPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        PickerComponent.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        allSlots.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
    ) -> UIView {
        let label = UILabel()
        label.font = R.typo.body1
        label.textColor = R.color.primary87()
        label.backgroundColor = .clear
        label.layer.cornerRadius = 0
        label.textAlignment = .center
        label.clipsToBounds = true
        label.text = DateHelper.Formatters.time24GMT0Formatter.string(from: allSlots[row])

        DispatchQueue.main.async { // chance color of the middle row
            if let label = pickerView.view(forRow: row, forComponent: component) as? UILabel {
                label.textColor = R.color.secondary100()
                label.font = R.typo.body1
                label.backgroundColor = R.color.brandPrimary()
                label.layer.cornerRadius = 8
                label.textAlignment = .center
            }
        }

        return label
    }
}

// MARK: - UIGestureRecognizerDelegate

extension TimeSlotsPickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
