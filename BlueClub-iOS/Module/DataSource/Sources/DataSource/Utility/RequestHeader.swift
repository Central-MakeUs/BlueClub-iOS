//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

enum RequestHeader {
    
    static let get: [String: String] = [
        "accept": "application/json;charset=UTF-8"
    ]
    static let post: [String: String] = [
        "Content-Type": "application/json;charset=UTF-8",
        "accept": "application/json;charset=UTF-8"
    ]
    
    // (accessToken, refreshToken)
    static func withTokens(accessToken: String, refreshToken: String) -> [String: String] {
        [
            "Content-Type": "application/json;charset=UTF-8",
            "accept": "application/json;charset=UTF-8",
            "Authorization": "Bearer " + accessToken,
            "Authorization-refresh": "Bearer " + refreshToken
        ]
    }
}
