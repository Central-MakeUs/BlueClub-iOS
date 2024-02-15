//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public protocol UserNetworkable {
    
    func detailsPost(_ dto: DetailsDTO) async throws
    func detailsPatch(_ dto: DetailsDTO) async throws
    func withdrawal() async throws
}
