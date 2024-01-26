//
//  Home.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/27/24.
//

import ComposableArchitecture
import Domain

@Reducer
struct Home {
    
    struct State: Equatable {
        let job: JobOption = .caddy
        let name: String = "회원"
        var 달성수입: Int? = .none
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
