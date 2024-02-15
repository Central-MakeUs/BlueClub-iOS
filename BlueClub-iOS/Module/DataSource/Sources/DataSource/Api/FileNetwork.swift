//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Domain
import MightyCombine

public struct FileNetwork {
    
    private let path = "/file"
    private let userRespository: UserRepositoriable
    private var token: String {
        userRespository.getToken()
    }
    
    public init(userRespository: UserRepositoriable) {
        self.userRespository = userRespository
    }
}

extension FileNetwork: FileNetworkable {
    
    public func homeBanner() async throws -> [String] {
        let header = RequestHeader.withToken(accessToken: self.token)
        
        return try await EndPoint
            .init(Const.baseUrl)
            .httpHeaders(header)
            .urlPaths([
                self.path,
                "/home",
                "/banner"])
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<[String]>.self)
            .tryMap { try handleServerResponseResult($0) }
            .asyncThrows
    }
}
