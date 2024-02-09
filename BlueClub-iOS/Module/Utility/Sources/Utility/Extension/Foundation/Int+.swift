//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation

public extension Int {
    
    func withComma() -> String {
        formatNumber(self)
    }
}

fileprivate func formatNumber(_ number: Int) -> String {
    formatter.string(from: NSNumber(value: number)) ?? ""
}

fileprivate var formatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    formatter.groupingSeparator = ","
    formatter.usesGroupingSeparator = true
    return formatter
}
