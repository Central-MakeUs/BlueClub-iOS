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

public class UserService: UserServiceable {
    
    @UserDefault("accessToken") private var accessToken: String?
    @UserDefault("refreshToken") private var refreshToken: String?
    
    public init() { }
    private let path = "/user"
    
    public func detailsPost(_ dto: DetailsDTO) async throws {
        
        var header = RequestHeader.post
        if let accessToken, let refreshToken {
            header["Authorization"] = "Bearer \(accessToken)"
            header["Authorization-refresh"] = "Bearer \(refreshToken)"
        }
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
    
    public func detailsPatch() async throws {
//        try init EndPoint
//            .init(Const.baseUrl)
//            .urlPaths([path, "/details"])
//            .httpMethod(.put)
    }
    
    public func withdrawal() async throws {
        
    }
}

extension UserService: TokenAccessible {
    public func registAccessToken(_ token: String) {
        self.accessToken = token
    }
    
    public func registRefreshToken(_ token: String) {
        self.refreshToken = token
    }
    
    public func getTokens() -> (String?, String?) {
        (self.accessToken, self.refreshToken)
    }
}
