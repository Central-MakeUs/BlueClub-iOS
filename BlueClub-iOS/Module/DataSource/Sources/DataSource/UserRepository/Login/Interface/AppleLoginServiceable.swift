//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation
import Domain

public protocol AppleLoginServiceable {
    @MainActor var request: () async throws -> SocialLoginUser { get set }
}
