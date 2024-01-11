//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public protocol UserRepositoriable {
    
    var requestUserInfo: (_ loginMethod: LoginMethod) async throws -> LoginUserInfo { get set }
    var hasLogin: Bool { get }
    var getUserInfo: () -> LoginUserInfo? { get set }
    var registInfo: (RegisterUserInfo) -> Void { get set } // Job, StartYear, nickname
}
