//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Domain
import DependencyContainer
import Foundation

public class UserRepository: UserRepositoriable {
    
    private let dependencies: Container
    private var appleLogin: AppleLoginRequestable { dependencies.resolve() }
    
    public init(dependencies: Container) {
        self.dependencies = dependencies
    }

    public lazy var requestUserInfo: (Domain.LoginMethod) async throws -> Domain.SocialLoginUserInfo = { method in
        try await self.appleLogin.request()
    }
}
