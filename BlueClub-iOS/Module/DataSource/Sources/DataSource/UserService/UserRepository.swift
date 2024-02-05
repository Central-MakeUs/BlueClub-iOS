//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Domain
import DependencyContainer
import Architecture

public class UserRepository: LoginAccessible {
    
    // MARK: - Dependencies
    private let dependencies: Container
    private var appleLogin: AppleLoginServiceable { dependencies.resolve() }
    private var kakaoLogin: KakaoLoginServiceable { dependencies.resolve() }
    
    // MARK: - Data
    @UserDefault("loginUser") private var loginUser: SocialLoginUser?
    @UserDefault("userInfo") private var userInfo: AuthDTO?
    @UserDefault("accessToken") private var accessToken: String?
    @UserDefault("refreshToken") private var refreshToken: String?
    
    public init(dependencies: Container) {
        self.dependencies = dependencies
    }
    
    public var hasLogin: Bool { loginUser != nil }
    
    public func requestLogin(_ loginMethod: Domain.LoginMethod) async throws -> Domain.SocialLoginUser {
        switch loginMethod {
        case .apple:
            return try await self.appleLogin.request()
        case .kakao:
            return try await self.kakaoLogin.request()
        }
    }
    
    public func registLoginUser(_ user: Domain.SocialLoginUser) {
        self.loginUser = user
    }
    
    public func getLoginUser() -> Domain.SocialLoginUser? {
        self.loginUser
    }
}

extension UserRepository: UserInfoAccessible {
    
    public func registUserInfo(_ userInfo: AuthDTO) {
        self.userInfo = userInfo
    }
    
    public func updateUserInfo(_ userInfo: Domain.DetailsDTO) {
        var new = self.userInfo
        new?.nickname = userInfo.nickname
        new?.job = userInfo.job
        new?.monthlyTargetIncome = userInfo.monthlyTargetIncome
        self.userInfo = new
        
    }
    
    public func getUserInfo() -> AuthDTO? {
        self.userInfo
    }
}

extension UserRepository: TokenAccessible {

    public func registAccessToken(_ token: String) {
        self.accessToken = token
    }
    
    public func registRefreshToken(_ token: String) {
        self.refreshToken = token
    }
    
    public func getTokens() -> (String?, String?) {
        (self.accessToken, self.refreshToken)
    }
}