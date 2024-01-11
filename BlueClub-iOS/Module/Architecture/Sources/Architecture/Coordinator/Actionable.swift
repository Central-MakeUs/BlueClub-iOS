//
//  File.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import Foundation

public protocol Actionable {
    
    associatedtype Action: Equatable
    
    @MainActor func send(_ action: Action)
}
