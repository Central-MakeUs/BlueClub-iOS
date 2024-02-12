//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public typealias UserRepositoriable = LoginAccessible & UserInfoAccessible & TokenAccessible

public protocol LoginAccessible {
    var hasLogin: Bool { get }
    func reset()
    func requestLogin(_ loginMethod: LoginMethod) async throws -> SocialLoginUser
    func registLoginUser(_ user: SocialLoginUser)
    func getLoginUser() -> SocialLoginUser?
}

public protocol UserInfoAccessible {
    func registUserInfo(_ userInfo: AuthDTO)
    func updateUserInfo(_ userInfo: DetailsDTO)
    func getUserInfo() -> AuthDTO?
}

public protocol TokenAccessible {
    func registAccessToken(_ token: String)
    func registRefreshToken(_ token: String)
    func getToken() -> String
}
