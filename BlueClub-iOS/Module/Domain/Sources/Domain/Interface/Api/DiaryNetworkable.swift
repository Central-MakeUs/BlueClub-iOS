//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation

public protocol DiaryNetworkable {
    
    @discardableResult func diary(_ dto: Encodable, job: JobOption) async throws -> Int
    @discardableResult func diaryDayOff(date: String) async throws -> Int
    
    func record() async throws -> DiaryRecordDTO
}

