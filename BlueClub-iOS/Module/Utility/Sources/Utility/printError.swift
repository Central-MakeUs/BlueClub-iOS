//
//  printError.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public func printError(
    _ error: Error,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("❌ Error: \(error) occurred in \(fileName) at line \(line), function: \(function)")
    #endif
}
