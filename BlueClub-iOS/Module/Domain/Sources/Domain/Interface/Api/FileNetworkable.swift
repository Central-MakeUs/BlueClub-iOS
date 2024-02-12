//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Foundation

public protocol FileNetworkable {
    
    func homeBanner() async throws -> [String]
}
