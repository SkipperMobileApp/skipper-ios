//
//  ReportMentorViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.06.2023.
//

import Foundation

class ReportMentorViewModel {
    @Event private(set) var sendReportEvent: Void?
    @Event private(set) var errorEvent: Error?

    @Published private(set) var mentorName: String?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var selectedTypeIndex: Int?

    @Injected() private var authRepository: AuthRepository
    @Injected() private var reportRepository: ReportRepository
    @Injected() private var userRepository: UserRepository

    private let mentorId: String

    let reportTypes: [ReportType] = ReportType.allCases

    init(mentorId: String) {
        self.mentorId = mentorId
    }

    func loadData() {
        isLoading = true

        Task {
            do {
                let mentor = try await userRepository.mentor(mentorId: mentorId)
                mentorName = [mentor.firstName, mentor.lastName].joined(separator: " ")
            } catch {
                errorEvent = error
            }

            isLoading = false
        }
    }

    func validate(text: String) -> String? {
        var results: [String] = []

        if selectedTypeIndex == nil {
            results.append("Тип занятия не выбран")
        }

        if text.isEmpty {
            results.append("Описание проблемы не должно быть пустым")
        }

        return results.isEmpty ? nil : results.joined(separator: "\n")
    }

    func sendReport(text: String) {
        isLoading = true

        Task {
            do {
                guard let selectedTypeIndex else {
                    throw AppError(message: "Причина обращения не выбрана")
                }

                guard let mentorName else {
                    throw AppError(message: "Ментор не найден")
                }

                guard let userId = try await authRepository.currentUser(forceUpdate: false)?.id
                else {
                    throw AppError(message: "Пользователь не найден")
                }

                let model = ReportMentorModel(
                    userId: userId,
                    mentorId: mentorId,
                    mentorName: mentorName,
                    reason: reportTypes[selectedTypeIndex].reportReason,
                    text: text
                )

                try await reportRepository.sendReport(report: model)

                sendReportEvent = ()
            } catch {
                errorEvent = error
            }

            isLoading = false
        }
    }

    func selectType(at index: Int) {
        guard index >= 0, index < reportTypes.count else { return }

        selectedTypeIndex = index
    }
}

// MARK: - ViewModels

extension ReportMentorViewModel {
    enum ReportType: String, CaseIterable {
        case fraud
        case offensiveBehaviour = "offensive_behaviour"
        case profileTroubles = "profile_troubles"
        case other

        var title: String {
            switch self {
            case .fraud: return "Мошенничество"
            case .offensiveBehaviour: return "Оскорбительное поведение"
            case .profileTroubles: return "Проблемы с профилем"
            case .other: return "Другое"
            }
        }

        fileprivate var reportReason: ReportReason {
            switch self {
            case .fraud: return .fraud
            case .offensiveBehaviour: return .offensiveBehaviour
            case .profileTroubles: return .profileTroubles
            case .other: return .other
            }
        }
    }
}
