//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import Domain

func handleServerResponseCode<T: Codable>(_ response: ServerResponse<T>) throws {
    switch response.code {
    case "CREATED", "SUCCESS":
        return
    default:
        throw ServerError.unknownError
    }
}

func handleServerResponseResult<T: Codable>(_ response: ServerResponse<T>) throws -> T {
    guard response.code == "SUCCESS" ||
          response.code == "CREATED"
    else { throw ServerError.unknownError }
    guard let result = response.result else {
        throw ServerError.resultNotFound
    }
    return result
}

func httpResponseHandler(_ response: HTTPURLResponse) throws {
    guard (200...299).contains(response.statusCode) else {
        throw ServerError.REQUEST_ERROR_001
    }
}
