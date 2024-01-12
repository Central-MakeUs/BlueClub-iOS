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
    
    @UserDefault("loginUser") private var loginUser: SocialLoginUser?
    @UserDefault("userInfo") private var userInfo: UserInfo?
    
    public init(dependencies: Container) {
        self.dependencies = dependencies
    }
    
    public var hasLogin: Bool { loginUser != nil }
    
    public lazy var requestLogin: (LoginMethod) async throws -> SocialLoginUser = { method in
        let user = try await self.appleLogin.request()
        self.loginUser = user
        return user
    }
    
    public lazy var getUser: () -> SocialLoginUser? = {
        self.loginUser
    }
    
    public lazy var registUserInfo: (UserInfo) -> Void = { userInfo in
        self.userInfo = userInfo
    }
    
    public lazy var getUserInfo: UserInfo? = {
        self.userInfo
    }()
}
