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
    private let targetIncome: Int
    
    var shouldNavigateToBoast = false
    var isAvailable: Bool {
        if workType == .dayOff { return true }
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
    // MARK: - (ID, Date)
    private var originalDiary: (Int, String)?
    
    @Published var isLoading = false
    @Published var keyboardAppeared = false
    @Published var showScheduleTypeSheet = false
    @Published var job: JobOption = .caddy
    @Published var workType: WorkType?
    @Published var date: Date = .now
    @Published var showMemoSheet = false
    @Published var memo = ""
    @Published var expenditure = ""
    @Published var saving = ""
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    var dateFormatted: String { date.dateString() }
    
    var contributePercent: Int? {
        let sum = self.totalSum?.removeComma()
        guard
            let sum,
            sum >= 10000
        else { return nil }
        return Int((Double(sum) / Double(targetIncome)) * 100)
    }
    
    // MARK: - Dependencies
    weak var coordinator: ScheduleNoteCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    private var diaryApi: DiaryNetworkable { dependencies.resolve() }
    
    init(
        coordinator: ScheduleNoteCoordinator?,
        dependencies: Container = .live,
        targetIncome: Int
    ) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        self.targetIncome = targetIncome
        
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
        
        $date
            .receive(on: DispatchQueue.main)
            .sink { date in
                Task { @MainActor in
                    self.isLoading = true
                    self.send(.fetchDetailByDate)
                }
            }.store(in: &cancellables)
    }
}

extension ScheduleEditViewModel: Actionable {

    enum Action {
        case fetchUserInfo
        case editByDate(String)
        case fetchDetailById(Int)
        case fetchDetailByDate
        case handleFetchedDiary(any DiaryDTO)
        case boast
        
        case showScheduleTypeSheet
        case save
        case saveCaddy
        case saveRider
        case saveDailyWorker
        case reset
    }
    
    func send(_ action: Action) {
        switch action {
        case .fetchUserInfo:
            let userInfo = userRepository.getUserInfo()
            self.job = .init(title: userInfo?.job ?? "")
            
        case .editByDate(let dateString):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let date = dateFormatter.date(from: dateString)
            guard let date else { return }
            
            if dateString != date.dateString() {
                self.date = date
            }
            
        case .fetchDetailById(let diaryId):
            Task { @MainActor in
                do {
                    self.isLoading = true
                    switch self.job {
                    case .caddy:
                        var diary: DiaryCaddyDTO = try await diaryApi.getDiaryById(
                            job: self.job,
                            id: diaryId)
                        diary.id = diaryId
                        self.send(.handleFetchedDiary(diary))
                    case .rider:
                        var diary: DiaryRiderDTO = try await diaryApi.getDiaryById(
                            job: self.job,
                            id: diaryId)
                        diary.id = diaryId
                        self.send(.handleFetchedDiary(diary))
                    case .dayWorker:
                        var diary: DiaryDayWorkerDTO = try await diaryApi.getDiaryById(
                            job: self.job,
                            id: diaryId)
                        diary.id = diaryId
                        self.send(.handleFetchedDiary(diary))
                    }
                } catch {
                    self.isLoading = false
                    printError(error)
                }
            }
            
        case .fetchDetailByDate:
            Task { @MainActor in
                do {
                    self.isLoading = true
                    switch self.job {
                    case .caddy:
                        let diary: DiaryCaddyDTO = try await diaryApi.getDiaryByDate(
                            job: self.job,
                            date: date)
                        self.send(.handleFetchedDiary(diary))
                    case .rider:
                        let diary: DiaryRiderDTO = try await diaryApi.getDiaryByDate(
                            job: self.job,
                            date: date)
                        self.send(.handleFetchedDiary(diary))
                    case .dayWorker:
                        let diary: DiaryDayWorkerDTO = try await diaryApi.getDiaryByDate(
                            job: self.job,
                            date: date)
                        self.send(.handleFetchedDiary(diary))
                    }
                } catch {
                    self.isLoading = false
                    self.send(.reset)
                    printError(error)
                }
            }
            
        case .handleFetchedDiary(let diary):
            if let diary = diary as? DiaryCaddyDTO {
                self.workType = .init(rawValue: diary.worktype)
                self.roundingCount = diary.rounding
                self.caddyFee = diary.caddyFee.withComma()
                self.overFee = diary.overFee.withComma()
                self.topDressing = diary.topdressing
                
                guard let id = diary.id else { return }
                let dateString = diary.dateDate.dateString()
                self.originalDiary = (id, dateString)
            } else if let diary = diary as? DiaryRiderDTO {
                self.workType = .init(rawValue: diary.worktype)
                self.deliveryCount = diary.numberOfDeliveries
                self.deliveryIncome = diary.incomeOfDeliveries.withComma()
                self.promotionCount = diary.numberOfPromotions
                self.promotionIncome = diary.incomeOfPromotions.withComma()
                
                guard let id = diary.id else { return }
                let dateString = diary.dateDate.dateString()
                self.originalDiary = (id, dateString)
            } else if let diary = diary as? DiaryDayWorkerDTO {
                self.workType = .init(rawValue: diary.worktype)
                self.placeName = diary.place
                self.dailyWage = diary.dailyWage.withComma()
                self.typeOfJob = diary.typeOfJob
                self.numberOfWork = diary.numberOfWork
                
                guard let id = diary.id else { return }
                let dateString = diary.dateDate.dateString()
                self.originalDiary = (id, dateString)
            }
            self.isLoading = false
            
        case .boast:
            self.shouldNavigateToBoast = true
            self.send(.save)
            
        case .showScheduleTypeSheet:
            self.showScheduleTypeSheet = true
            
        case .save:
            guard self.isAvailable else { return }
            switch self.job {
            case .caddy:
                self.send(.saveCaddy)
            case .rider:
                self.send(.saveRider)
            case .dayWorker:
                self.send(.saveDailyWorker)
            }
            
        case .saveCaddy:
            let dto: DiaryCaddyDTO = .init(
                worktype: self.workType?.title ?? "근무",
                memo: self.memo,
                income: self.totalSum?.removeComma() ?? 0,
                expenditure: self.expenditure.removeComma(),
                saving: self.saving.removeComma(),
                date: self.date.dateString(),
                rounding: self.roundingCount,
                caddyFee: self.caddyFee.removeComma(),
                overFee: self.overFee.removeComma(),
                topdressing: self.topDressing)
            Task {
                do {
                    if let originalDiary, originalDiary.1 == self.dateFormatted {
                        try await diaryApi.diaryPatch(
                            id: originalDiary.0,
                            dto: dto,
                            job: .caddy)
                        
                        self.coordinator?.navigator.pop()
                        if shouldNavigateToBoast {
                            self.coordinator?.send(.boast(originalDiary.0))
                        }
                    } else {
                        let id = try await diaryApi.diaryPost(
                            dto,
                            job: .caddy)
                        
                        self.coordinator?.navigator.pop()
                        if shouldNavigateToBoast {
                            self.coordinator?.send(.boast(id))
                        }
                    }
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
                date: self.date.dateString(),
                numberOfDeliveries: self.deliveryCount,
                incomeOfDeliveries: self.deliveryIncome.removeComma(),
                numberOfPromotions: self.promotionCount,
                incomeOfPromotions: self.promotionIncome.removeComma())
            Task {
                do {
                    if let originalDiary, originalDiary.1 == self.dateFormatted {
                        try await diaryApi.diaryPatch(
                            id: originalDiary.0,
                            dto: dto,
                            job: .rider)
                        
                        self.coordinator?.navigator.pop()
                        if shouldNavigateToBoast {
                            self.coordinator?.send(.boast(originalDiary.0))
                        }
                    } else {
                        let id = try await diaryApi.diaryPost(
                            dto,
                            job: .rider)
                        
                        self.coordinator?.navigator.pop()
                        if shouldNavigateToBoast {
                            self.coordinator?.send(.boast(id))
                        }
                    }
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
                date: self.date.dateString(),
                place: self.placeName,
                dailyWage: self.dailyWage.removeComma(),
                typeOfJob: self.typeOfJob,
                numberOfWork: self.numberOfWork)
            Task {
                do {
                    if let originalDiary, originalDiary.1 == self.dateFormatted {
                        try await diaryApi.diaryPatch(
                            id: originalDiary.0,
                            dto: dto,
                            job: .dayWorker)
                        
                        self.coordinator?.navigator.pop()
                        if shouldNavigateToBoast {
                            self.coordinator?.send(.boast(originalDiary.0))
                        }
                    } else {
                        let id = try await diaryApi.diaryPost(
                            dto,
                            job: .dayWorker)
                        
                        self.coordinator?.navigator.pop()
                        if shouldNavigateToBoast {
                            self.coordinator?.send(.boast(id))
                        }
                    }
                } catch {
                    printError(error)
                }
            }
            
        case .reset:
            Task { @MainActor in
                self.workType = .none
                self.memo = ""
                self.expenditure = ""
                self.saving = ""
                self.roundingCount = 0
                self.caddyFee = ""
                self.overFee = ""
                self.topDressing = false
                self.deliveryCount = 0
                self.deliveryIncome = ""
                self.promotionCount = 0
                self.promotionIncome = ""
                self.placeName = ""
                self.dailyWage = ""
                self.typeOfJob = ""
                self.numberOfWork = 0.0
            }
        }
    }
}

fileprivate extension Date {
    
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
