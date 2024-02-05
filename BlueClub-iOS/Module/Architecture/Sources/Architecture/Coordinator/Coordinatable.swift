//
//  File.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import Foundation
import Navigator

public protocol Coordinatorable: AnyObject, Actionable, Navigatable {

}

public extension Coordinatorable {
    
    @MainActor func pop() {
        self.navigator.pop()
    }
}
