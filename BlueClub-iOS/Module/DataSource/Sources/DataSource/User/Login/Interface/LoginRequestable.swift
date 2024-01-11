//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation
import Domain

public protocol LoginRequestable {
    var request: () async throws -> SocialLoginUserInfo { get set }
}
