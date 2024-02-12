//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation

public protocol DiaryNetworkable {
    
    func getDiaryById<T: DiaryDTO>(job: JobOption, id: Int) async throws -> T
    func getDiaryByDate<T: DiaryDTO>(job: JobOption, date: Date) async throws -> T
    @discardableResult func diaryPost(_ dto: Encodable, job: JobOption) async throws -> Int
    @discardableResult func diaryPatch(id: Int, dto: Encodable, job: JobOption) async throws -> Int
    
    func list(monthIndex: Int) async throws -> [DiaryListDTO.MonthlyRecord]
    func record() async throws -> DiaryRecordDTO
}

