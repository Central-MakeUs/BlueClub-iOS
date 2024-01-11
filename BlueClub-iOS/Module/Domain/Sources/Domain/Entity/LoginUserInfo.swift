//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public struct LoginUserInfo: Codable {
    
    public let id: String
    public let token: String
    public var name: String?
    public var email: String?
    public let loginMethod: LoginMethod
    
    public init(
        id: String,
        token: String,
        name: String?,
        email: String?,
        loginMethod: LoginMethod
    ) {
        self.id = id
        self.token = token
        self.name = name
        self.email = email
        self.loginMethod = loginMethod
    }
}
