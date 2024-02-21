//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public func printLog(
    message: String? = nil,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    var logMessage = "🟢 Log: `\(function)` executed in `\(fileName)` line \(line), "
    if let message {
        logMessage += "message is `\(message)`"
    }
    print(logMessage)
    #endif
}
