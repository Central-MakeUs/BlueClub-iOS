//
//  File.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import Foundation
import Navigator

public protocol Coordinatorable: AnyObject, Actionable, Navigatable {

    var child: (any Coordinatorable)? { get set }
    var parent: (any Coordinatorable)? { get set }
    
    func start(parent: (any Coordinatorable)?)
}
