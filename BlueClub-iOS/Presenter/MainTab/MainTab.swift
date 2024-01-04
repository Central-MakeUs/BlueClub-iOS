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
        
        var icon: Icons {
            switch self {
            case .home:
                return .home_outline
            case .note:
                return .calendar_outline
            case .community:
                return .chat_outline
            case .myPage:
                return .my_outline
            }
        }
        
        var selectedIcon: Icons {
            switch self {
            case .home:
                return .home_solid
            case .note:
                return .calendar_solid
            case .community:
                return .chat_solid
            case .myPage:
                return .my_solid
            }
        }
    }
}
