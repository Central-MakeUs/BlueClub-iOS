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
    private var origianalDiaryId: Int?
    
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
        case fetchDetail(Int)
        case handlerFetchedDiary(any DiaryDTO)
        case setDate(Date)
        
        case showScheduleTypeSheet
        case save
        case saveCaddy
        case saveRider
        case saveDailyWorker
    }
    
    func send(_ action: Action) {
        switch action {
        case .fetchUserInfo:
            let userInfo = userRepository.getUserInfo()
            self.job = .init(title: userInfo?.job ?? "")
            
        case .fetchDetail(let diaryId):
            Task { @MainActor in
                do {
                    self.isLoading = true
                    self.origianalDiaryId = diaryId
                    switch self.job {
                    case .caddy:
                        let diary: DiaryCaddyDTO = try await diaryApi.getDiary(
                            job: self.job,
                            id: diaryId)
                        self.send(.handlerFetchedDiary(diary))
                    case .rider:
                        let diary: DiaryRiderDTO = try await diaryApi.getDiary(
                            job: self.job,
                            id: diaryId)
                        self.send(.handlerFetchedDiary(diary))
                    case .dayWorker:
                        let diary: DiaryDayWorkerDTO = try await diaryApi.getDiary(
                            job: self.job,
                            id: diaryId)
                        self.send(.handlerFetchedDiary(diary))
                    }
                } catch {
                    printError(error)
                }
            }
            
        case .handlerFetchedDiary(let diary):
            if let diary = diary as? DiaryCaddyDTO {
                self.workType = .init(rawValue: diary.worktype)
                self.roundingCount = diary.rounding
                self.caddyFee = diary.caddyFee.withComma()
                self.overFee = diary.overFee.withComma()
                self.topDressing = diary.topdressing
            } else if let diary = diary as? DiaryRiderDTO {
                self.workType = .init(rawValue: diary.worktype)
                self.deliveryCount = diary.numberOfDeliveries
                self.deliveryIncome = diary.incomeOfDeliveries.withComma()
                self.promotionCount = diary.numberOfPromotions
                self.promotionIncome = diary.incomeOfPromotions.withComma()
            } else if let diary = diary as? DiaryDayWorkerDTO {
                self.workType = .init(rawValue: diary.worktype)
                self.placeName = diary.place
                self.dailyWage = diary.dailyWage.withComma()
                self.typeOfJob = diary.typeOfJob
                self.numberOfWork = diary.numberOfWork
            }
            self.isLoading = false
            
        case .setDate(let date):
            self.date = date
            
        case .showScheduleTypeSheet:
            self.showScheduleTypeSheet = true
            
        case .save:
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
                date: formatDate(self.date),
                rounding: self.roundingCount,
                caddyFee: self.caddyFee.removeComma(),
                overFee: self.overFee.removeComma(),
                topdressing: self.topDressing)
            Task {
                do {
                    if let origianalDiaryId {
                        try await diaryApi.diaryPatch(
                            id: origianalDiaryId,
                            dto: dto,
                            job: .caddy)
                    } else {
                        try await diaryApi.diaryPost(dto, job: .caddy)
                    }
                    self.coordinator?.navigator.pop()
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
                    if let origianalDiaryId {
                        try await diaryApi.diaryPatch(
                            id: origianalDiaryId,
                            dto: dto,
                            job: .rider)
                    } else {
                        try await diaryApi.diaryPost(
                            dto,
                            job: .rider)
                    }
                    self.coordinator?.navigator.pop()
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
                    if let origianalDiaryId {
                        try await diaryApi.diaryPatch(
                            id: origianalDiaryId,
                            dto: dto,
                            job: .dayWorker)
                    } else {
                        try await diaryApi.diaryPost(
                            dto,
                            job: .dayWorker)
                    }
                    self.coordinator?.navigator.pop()
                } catch {
                    printError(error)
                }
            }
        }
    }
}

fileprivate func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}
