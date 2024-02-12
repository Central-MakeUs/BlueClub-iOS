//
//  Home.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/27/24.
//

import SwiftUI
import Architecture
import Domain
import DependencyContainer
import Utility

final class HomeViewModel: ObservableObject {
    
    // MARK: - Dependencies
    weak var coodinator: HomeCoordinator?
    private let container: Container
    private var dateService: DateServiceable { container.resolve() }
    private var userRepository: UserRepositoriable { container.resolve() }
    private var diaryApi: DiaryNetworkable { container.resolve() }
    
    init(
        coodinator: HomeCoordinator,
        container: Container = .live
    ) {
        self.coodinator = coodinator
        self.container = container
    }
    
    // MARK: - Datas
    @Published var user: AuthDTO?
    @Published var record: DiaryRecordDTO?
    @Published var shouldReloadProgressBar = false
    @Published var currentMonth: String?
}

extension HomeViewModel: Actionable {

    enum Action: Equatable {
        case fetchData
    }
    
    func send(_ action: Action) {
        switch action {
            
        case .fetchData:
            Task { @MainActor in 
                do {
                    self.user = userRepository.getUserInfo()
                    let (_, month, _) = dateService.toDayInt(0)
                    self.currentMonth = String(month)
                    self.record = try await diaryApi.record()
                    self.shouldReloadProgressBar.toggle()
                } catch {
                    printError(error)
                }
            }
        }
    }
}
