//
//  MainTab.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

@Reducer
struct MainTab {
 
    struct State: Equatable {
        @BindingState var currentTab: TabItem = .home
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case didTap(TabItem)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .didTap(let tab):
                state.currentTab = tab
                return .none
            case .binding:
                return .none
            }
        }
    }
}

extension MainTab {
    
    enum TabItem: CaseIterable {
        case home, note, community, myPage
        
        var title: String {
            switch self {
            case .home:
                return "홈"
            case .note:
                return "근무수첩"
            case .community:
                return "커뮤니티"
            case .myPage:
                return "마이페이지"
            }
        }
        
        var icon: Icon {
            switch self {
            case .home:
                return .home04
            case .note:
                return .calendar
            case .community:
                return .chat01
            case .myPage:
                return .user
            }
        }
        
        var selectedIcon: Icon {
            switch self {
            case .home:
                return .home04Filled
            case .note:
                return .calendarFilled
            case .community:
                return .chat01Filled
            case .myPage:
                return .userFilled
            }
        }
    }
}
