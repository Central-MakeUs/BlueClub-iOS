//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation

public protocol DiaryNetworkable {
    
    func diary(_ dto: DiaryDTO) async throws
    func record() async throws -> DiaryRecordDTO
}
