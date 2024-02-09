//
//  MainTab.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI
import DesignSystem
import Architecture
import Navigator

final class MainTabViewModel: ObservableObject {
    
    @Published var currentTab: MainTabItem = .home
    
    let navigator: Navigator
    
    lazy var homeCoordinator: HomeCoordinator = {
        .init(navigator: navigator, parent: self)
    }()
    let scheudleNoteCoordinator: ScheduleNoteCoordinator
    let myPageCoordinator: MyPageCoordinator
    
    init(navigator: Navigator) {
        self.navigator = navigator
        self.scheudleNoteCoordinator = .init(navigator: navigator)
        self.myPageCoordinator = .init(navigator: navigator)
    }
}

extension MainTabViewModel: Actionable {
    
    enum Action {
        case scheduleNoteEdit
        case didTapTab(MainTabItem)
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .didTapTab(let tabItem):
            self.currentTab = tabItem
            
        case .scheduleNoteEdit:
            self.currentTab = .note
            scheudleNoteCoordinator.send(.scheduleEdit)
        }
    }
}

enum MainTabItem: CaseIterable {
    case home, note, myPage
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .note:
            return "근무수첩"
        case .myPage:
            return "마이페이지"
        }
    }
    
    var icon: Icons {
        switch self {
        case .home:
            return .home_solid
        case .note:
            return .calendar_solid
        case .myPage:
            return .my_solid
        }
    }
}
