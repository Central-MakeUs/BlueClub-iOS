//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import MightyCombine
import Domain

public class AuthNetwork: AuthNetworkable {
    
    private let userRespository: UserRepositoriable
    private var token: String {
        userRespository.getToken()
    }
    
    public init(userRespository: UserRepositoriable) {
        self.userRespository = userRespository
    }
    
    
    private let path = "/auth"
    
    public func auth(_ user: SocialLoginUser) async throws -> AuthDTO {
        
        let body: [String: Any] = [
            "socialId": user.id,
            "socialType": user.loginMethod.title,
            "name": user.name,
            "nickname": "",
            "email": user.email,
            "profileImage": ""
        ]
        
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([path])
            .httpMethod(.post)
            .httpBody(body)
            .httpHeaders(RequestHeader.post)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<AuthDTO>.self)
            .tryMap { try handleServerResponseResult($0) }
            .asyncThrows
    }
    
    public func duplicated(_ nickname: String) async throws -> Bool {
        let header = RequestHeader.withToken(accessToken: token)
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([path, "/duplicated"])
            .urlQueries(["nickname": nickname])
            .httpHeaders(header)
            .responseHandler { response in
                switch response.statusCode {
                case (200...299):
                    return
                case 400:
                    throw ServerError.닉네임은_10글자_이하로_작성해주세요
                case 409:
                    throw ServerError.해당_닉네임은_중복입니다
                default:
                    throw ServerError.unknownError
                }
            }
            .requestPublisher(expect: ServerResponse<Empty>.self)
            .tryMap {
                try handleServerResponseCode($0)
                return true
            }
            .asyncThrows
    }
    
    public func logout() async throws {
        let header = RequestHeader.withToken(accessToken: token)
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([path, "/logout"])
            .httpHeaders(header)
            .httpMethod(.post)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<AuthDTO>.self)
            .tryMap { try handleServerResponseCode($0) }
            .asyncThrows
    }
}
