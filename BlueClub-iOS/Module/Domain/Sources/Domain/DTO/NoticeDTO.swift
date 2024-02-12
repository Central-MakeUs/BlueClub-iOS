//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Foundation

public struct NoticeDTO: Codable, Identifiable {
    public let id: Int
    public let title: String
    public let content: String
    public let createAt: String
    
    public var dateString: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let inputDate = inputFormatter.date(from: createAt)
        guard let inputDate else { return "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.MM.dd"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return outputFormatter.string(from: inputDate)
    }
}
