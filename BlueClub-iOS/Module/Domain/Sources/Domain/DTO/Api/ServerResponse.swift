//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public struct ServerResponse<T: Codable>: Codable {
    public let code: String
    public let message: String
    public let result: T?
}


public struct Empty: Codable { }
