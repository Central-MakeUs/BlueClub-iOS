//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public func printLog(
    file: String = #file,
    function: String = #function
) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("🟢 Log: \(function) executed in \(fileName)")
    #endif
}
