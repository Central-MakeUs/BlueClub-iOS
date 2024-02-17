//
//  File.swift
//  
//
//  Created by 김인섭 on 2/17/24.
//

import Foundation

public protocol DiaryDTO: Codable {
    var id: Int? { get }
    var worktype: String { get }
    var memo: String { get }
    var income: Int { get }
    var expenditure: Int { get }
    var saving: Int { get }
    var date: String { get }
}

public extension DiaryDTO {
    var dateDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.date(from: date) ?? .now
    }
}
