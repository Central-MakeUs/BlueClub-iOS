//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation

public struct DiaryCaddyDTO: Codable {
    public let worktype: String
    public let memo: String
    public let income: Int
    public let expenditure: Int
    public let saving: Int
    public let date: String
    public let imageUrlList: String?
    public let rounding: Int
    public let caddyFee: Int
    public let overFee: Int
    public let topdressing: Bool
}

public protocol DiaryDTO: Codable { }
