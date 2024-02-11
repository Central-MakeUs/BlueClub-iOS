//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import MightyCombine
import Domain
import Architecture

public class UserNetwork: UserNetworkable {
    
    private let userRespository: UserRepositoriable
    private var token: String {
        userRespository.getToken()
    }
    
    public init(userRespository: UserRepositoriable) {
        self.userRespository = userRespository
    }
    
    private let path = "/user"
    
    public func detailsPost(_ dto: DetailsDTO) async throws {
        let header = RequestHeader.withToken(accessToken: token)
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([path, "/details"])
            .httpMethod(.post)
            .httpBody(dto)
            .httpHeaders(header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<Empty>.self)
            .tryMap { try serverResponseHandler($0) }
            .asyncThrows
    }
    
    public func detailsPatch(_ dto: DetailsDTO) async throws {
        let header = RequestHeader.withToken(accessToken: token)
        let body: [String : Any] = [
            "nickname": dto.nickname,
            "job": dto.job,
            "monthlyTargetIncome": dto.monthlyTargetIncome
        ]
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([path, "/details"])
            .httpMethod(.patch)
            .httpBody(body)
            .httpHeaders(header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<Empty>.self)
            .tryMap { try serverResponseHandler($0) }
            .asyncThrows
    }
    
    public func withdrawal() async throws {
        
    }
}
