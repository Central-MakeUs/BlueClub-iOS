//
//  Home.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/27/24.
//

import SwiftUI
import Architecture
import Domain

final class HomeViewModel: ObservableObject {
    
    weak var coodinator: HomeCoordinator?
    
    init(coodinator: HomeCoordinator) {
        self.coodinator = coodinator
    }
    
    let job: JobOption = .caddy
    let name: String = "회원"
    var 달성수입: Int? = .none
}

extension HomeViewModel: Actionable {

    enum Action: Equatable {
        
    }
    
    func send(_ action: Action) {
        
    }
}
