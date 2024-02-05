//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public struct SocialLoginUser: Codable {
    
    public let id: String
    public var name: String
    public var email: String
    public let loginMethod: LoginMethod
    
    public init(
        id: String,
        name: String?,
        email: String?,
        loginMethod: LoginMethod
    ) {
        self.id = id
        self.name = name ?? ""
        self.email = email ?? ""
        self.loginMethod = loginMethod
    }
}
