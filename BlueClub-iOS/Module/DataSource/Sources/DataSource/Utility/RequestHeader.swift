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
    
    static func withToken(accessToken: String) -> [String: String] {
        [
            "Content-Type": "application/json;charset=UTF-8",
            "accept": "application/json;charset=UTF-8",
            "Authorization": "Bearer " + accessToken
        ]
    }
    
    static func multiPartWithToken(accessToken: String) -> [String: String] {
        [
            "accept": "application/json;charset=UTF-8",
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer " + accessToken
        ]
    }
}
