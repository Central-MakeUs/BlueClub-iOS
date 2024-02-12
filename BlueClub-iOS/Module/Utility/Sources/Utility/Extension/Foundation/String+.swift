//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation

public extension String {
    
    func removeComma() -> Int {
        let clean = self.replacingOccurrences(of: ",", with: "")
        return Int(clean) ?? 0
    }
}
