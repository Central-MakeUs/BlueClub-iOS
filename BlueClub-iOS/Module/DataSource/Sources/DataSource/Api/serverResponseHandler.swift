//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import Domain

func serverResponseHandler<T: Codable>(_ response: ServerResponse<T>) throws {
    switch response.code {
    case "CREATED", "SUCCESS":
        return
    default:
        throw ServerError.unknownError
    }
}

func httpResponseHandler(_ response: HTTPURLResponse) throws {
    guard (200...299).contains(response.statusCode) else {
        throw ServerError.REQUEST_ERROR_001
    }
}
