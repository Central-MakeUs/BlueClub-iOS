//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public protocol AuthNetworkable {
    
    func auth(_ user: SocialLoginUser) async throws -> AuthDTO
    
    func duplicated(_ nickname: String) async throws -> Bool
    
    func logout() async throws
}
