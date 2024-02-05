//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import Domain

public protocol UserServiceable {
    
    func detailsPost(_ dto: DetailsDTO) async throws
    func detailsPatch() async throws
    func withdrawal() async throws
}
