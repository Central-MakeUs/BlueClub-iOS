//
//  InitialLogin.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/5/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SignUpEntry {
    
    struct State: Equatable {
        var currentTab: TabItem = .first
    }
    
    enum Action {
        case onAppear
        case onDisppaer
        case rotateToNext
        case didTapButton
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }
    private weak var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            
            case .onAppear:
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1.5)) {
                        await send(.rotateToNext, animation: .default)
                    }
                }.cancellable(id: CancelID.timer, cancelInFlight: true)
                
            case .onDisppaer:
                return .cancel(id: CancelID.timer)
                
            case .rotateToNext:
                switch state.currentTab {
                case .first:
                    state.currentTab = .second
                case .second:
                    state.currentTab = .third
                case .third:
                    state.currentTab = .first
                }
                return .none
                
            case .didTapButton:
                coordinator?.send(.signup)
                return .none
            }
        }
    }
}

extension SignUpEntry {
    
    enum TabItem: CaseIterable {
        
        case first, second, third
        
        var image: Image {
            switch self {
            case .first:
                return .init("initial1", bundle: .main)
            case .second:
                return .init("initial2", bundle: .main)
            case .third:
                return .init("initial3", bundle: .main)
            }
        }
    }
}
