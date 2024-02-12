//
//  ScheduleEditViewModel.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/6/24.
//

import Foundation
import DependencyContainer
import Domain
import Architecture
import DataSource
import UIKit
import Combine
import Utility

import Alamofire

class ScheduleEditViewModel: ObservableObject {
    
    // MARK: - Datas
    var isAvailable: Bool {
        switch self.job {
        case .caddy:
            return workType != nil &&
            roundingCount > 0 &&
            !caddyFee.isEmpty
        case .rider:
            return workType != nil &&
            deliveryCount > 0 &&
            !deliveryIncome.isEmpty
        case .dayWorker:
            return workType != nil &&
            !placeName.isEmpty &&
            !dailyWage.isEmpty
        }
    }
    private var cancellables = Set<AnyCancellable>()

    @Published var keyboardAppeared = false
    @Published var showScheduleTypeSheet = false
    @Published var job: JobOption = .caddy
    @Published var workType: WorkType?
    @Published var date: Date = .now
    @Published var showMemoSheet = false
    @Published var memo = ""
    @Published var expenditure = ""
    @Published var saving = ""
    
    // MARK: - Cadday Datas
    @Published var roundingCount = 0
    @Published var caddyFee = ""
    @Published var overFee = ""
    @Published var topDressing = false
    
    // MARK: - Rider Datas
    @Published var deliveryCount = 0
    @Published var deliveryIncome = ""
    @Published var promotionCount = 0
    @Published var promotionIncome = ""
    
    // MARK: - Temporary Datas
    @Published var placeName = ""
    @Published var dailyWage = ""
    @Published var typeOfJob = ""
    @Published var numberOfWork: Double = 0.0
    
    var totalSum: String? {
        switch self.job {
        case .caddy:
            let caddyFeeInt = caddyFee.removeComma()
            let overFeeInt = overFee.removeComma()
            let sum = caddyFeeInt + overFeeInt
            return sum.withComma()
        case .rider:
            let deliveryIncomeInt = deliveryIncome.removeComma()
            let promotionIncomeInt = promotionIncome.removeComma()
            let sum = deliveryIncomeInt + promotionIncomeInt
            return sum.withComma()
        case .dayWorker:
            return dailyWage
        }
    }
    
    // MARK: - Dependencies
    weak var coordinator: ScheduleNoteCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    private var diaryApi: DiaryNetworkable { dependencies.resolve() }
    
    init(
        coordinator: ScheduleNoteCoordinator,
        dependencies: Container = .live
    ) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.keyboardAppeared = true
            }).store(in: &cancellables)

          // 키보드가 사라질 때
          NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.keyboardAppeared = false
            }).store(in: &cancellables)
    }
}

extension ScheduleEditViewModel: Actionable {

    enum Action {
        case fetchUserInfo
        case showScheduleTypeSheet
        case save
        case saveCadday
        case saveRider
        case saveDailyWorker
        case saveDayOff
    }
    
    func send(_ action: Action) {
        switch action {
        case .fetchUserInfo:
//            let userInfo = userRepository.getUserInfo()
//            self.job = .init(title: userInfo?.job ?? "")
            break
            
        case .showScheduleTypeSheet:
            self.showScheduleTypeSheet = true
            
        case .save:
            guard self.workType != .dayOff else {
                return self.send(.saveDayOff)
            }
            
            switch self.job {
            case .caddy:
                self.send(.saveCadday)
            case .rider:
                self.send(.saveRider)
            case .dayWorker:
                self.send(.saveDailyWorker)
            }
            
        case .saveCadday:
            let dto: DiaryCaddyDTO = .init(
                worktype: self.workType?.title ?? "근무",
                memo: self.memo,
                income: self.totalSum?.removeComma() ?? 0,
                expenditure: self.expenditure.removeComma(),
                saving: self.saving.removeComma(),
                date: formatDate(self.date),
                rounding: self.roundingCount,
                caddyFee: self.caddyFee.removeComma(),
                overFee: self.overFee.removeComma(),
                topdressing: self.topDressing)
            Task {
                do {
                    try await diaryApi.diary(dto, job: .caddy)
                } catch {
                    printError(error)
                }
            }
            
        case .saveRider:
            let dto: DiaryRiderDTO = .init(
                worktype: self.workType?.title ?? "근무",
                memo: self.memo,
                income: self.totalSum?.removeComma() ?? 0,
                expenditure: self.expenditure.removeComma(),
                saving: self.saving.removeComma(),
                date: formatDate(self.date),
                numberOfDeliveries: self.deliveryCount,
                incomeOfDeliveries: self.deliveryIncome.removeComma(),
                numberOfPromotions: self.promotionCount,
                incomeOfPromotions: self.promotionIncome.removeComma())
            Task {
                do {
                    try await diaryApi.diary(dto, job: .caddy)
                    self.coordinator?.navigator.dismiss()
                } catch {
                    printError(error)
                }
            }
            
        case .saveDailyWorker:
            let dto: DiaryDayWorkerDTO = .init(
                worktype: self.workType?.title ?? "근무",
                memo: self.memo,
                income: self.totalSum?.removeComma() ?? 0,
                expenditure: self.expenditure.removeComma(),
                saving: self.saving.removeComma(),
                date: formatDate(self.date),
                place: self.placeName,
                dailyWage: self.dailyWage.removeComma(),
                typeOfJob: self.typeOfJob,
                numberOfWork: self.numberOfWork)
            Task {
                do {
                    try await diaryApi.diary(dto, job: .caddy)
                    self.coordinator?.navigator.dismiss()
                } catch {
                    printError(error)
                }
            }
            
        case .saveDayOff:
            Task {
                do {
                    try await diaryApi.diaryDayOff(date: formatDate(self.date))
                    self.coordinator?.navigator.dismiss()
                } catch {
                    printError(error)
                }
            }
        }
    }
}

enum WorkType: CaseIterable {
    case work, skipOff, dayOff
    
    var title: String {
        switch self {
        case .work:
            return "근무"
        case .skipOff:
            return "조퇴"
        case .dayOff:
            return "휴무"
        }
    }
}

fileprivate func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}
