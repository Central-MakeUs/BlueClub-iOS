//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public protocol UserRepositoriable {
    
    var requestUserInfo: (_ loginMethod: LoginMethod) async throws -> SocialLoginUserInfo { get set }
}
