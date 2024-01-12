//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public protocol UserRepositoriable {
    
    var hasLogin: Bool { get }
    
    var requestLogin: (_ loginMethod: LoginMethod) async throws -> SocialLoginUser { get set }
    var getUser: () -> SocialLoginUser? { get set }
    
    var registUserInfo: (UserInfo) -> Void { get set }
    var getUserInfo: UserInfo? { get set }
}
