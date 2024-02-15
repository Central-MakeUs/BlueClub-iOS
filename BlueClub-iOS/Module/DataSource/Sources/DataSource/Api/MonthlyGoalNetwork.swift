//
//  File.swift
//  
//
//  Created by 김인섭 on 2/11/24.
//

import Domain
import MightyCombine

public struct MonthlyGoalNetwork: MonthlyGoalNetworkable {
    
    private let path = "/monthly_goal"
    private let userRespository: UserRepositoriable
    private var header: [String: String] {
        let token = userRespository.getToken()
        return RequestHeader.withToken(accessToken: token)
    }
    
    public init(userRespository: UserRepositoriable) {
        self.userRespository = userRespository
    }
    
    public func post(
        year: Int,
        month: Int,
        targetIncome: Int
    ) async throws {
        let yearMonth = combineAsPath(
            year: year,
            month: month)
        let body: [String: Any] = [
            "yearMonth": yearMonth,
            "monthlyTargetIncome": targetIncome
        ]
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([path])
            .httpMethod(.post)
            .httpBody(body)
            .httpHeaders(header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<Empty>.self)
            .tryMap { try handleServerResponseCode($0) }
            .asyncThrows
    }
    
    public func get(
        year: Int,
        month: Int
    ) async throws -> Domain.MonthlyGoalDTO {
        let yearMonth = combineAsPath(
            year: year,
            month: month)
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([path, "/\(yearMonth)"])
            .httpMethod(.get)
            .httpHeaders(header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<MonthlyGoalDTO>.self)
            .tryMap { try handleServerResponseResult($0) }
            .asyncThrows
    }
}

fileprivate func combineAsPath(year: Int, month: Int) -> String {
    var monthString = String(month)
    if 10 > month {
        monthString = "0" + monthString
    }
    return String(year) + "-" + monthString
}
