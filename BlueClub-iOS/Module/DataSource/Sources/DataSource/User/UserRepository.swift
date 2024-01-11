//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Domain
import DependencyContainer
import Architecture

public class UserRepository: UserRepositoriable {
    
    private let dependencies: Container
    private var appleLogin: AppleLoginServiceable { dependencies.resolve() }
    
    @UserDefault("loginUser") private var loginUser: LoginUserInfo?
    @UserDefault("userInfo") private var userInfo: RegisterUserInfo?
    
    public init(dependencies: Container) {
        self.dependencies = dependencies
    }
    
    public var hasLogin: Bool { loginUser != nil }
    
    public lazy var requestUserInfo: (LoginMethod) async throws -> LoginUserInfo = { method in
        let user = try await self.appleLogin.request()
        self.loginUser = user
        return user
    }
    
    public lazy var getUserInfo: () -> LoginUserInfo? = {
        self.loginUser
    }
    
    public lazy var registInfo: (RegisterUserInfo) -> Void = { userInfo in
        self.userInfo = userInfo
    }
}
