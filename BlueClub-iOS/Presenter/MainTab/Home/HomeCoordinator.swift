//
//  HomeCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import Navigator
import Architecture

final class HomeCoordinator: Coordinatorable {
    
    var navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }   
}

extension HomeCoordinator {
    
    enum Action {
        case boastCollection
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .boastCollection:
            let view = BoastCollectionView(coordinator: self)
            navigator.push { view }
        }
    }
}
