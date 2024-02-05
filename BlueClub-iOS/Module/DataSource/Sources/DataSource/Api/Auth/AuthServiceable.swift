//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Domain

public protocol AuthServiceable {
    
    func auth(_ user: SocialLoginUser) async throws -> AuthDTO
    
    func duplicate(_ nickname: String) async throws -> Bool
    
    func logout() async throws
}
