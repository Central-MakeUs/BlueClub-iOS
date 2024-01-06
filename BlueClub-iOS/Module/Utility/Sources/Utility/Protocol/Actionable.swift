//
//  File.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import Foundation

public protocol Actionable {
    
    associatedtype Action: Equatable
    
    func reduce(_ action: Action)
}

public extension Actionable {
    
    func send(_ action: Action) {
        self.reduce(action)
    }
}
