//
//  File.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import Foundation

public extension Array where Element: Equatable {
    mutating func toggle(_ element: Element) {
        if let index = self.firstIndex(of: element) {
            self.remove(at: index)
        } else {
            self.append(element)
        }
    }
}
