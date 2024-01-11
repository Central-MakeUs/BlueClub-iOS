//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation
import Domain

public protocol LoginServiceable {
    var request: () async throws -> LoginUserInfo { get set }
}
