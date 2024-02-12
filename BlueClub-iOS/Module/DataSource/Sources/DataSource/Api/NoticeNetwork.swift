//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Domain
import DependencyContainer
import MightyCombine

public struct NoticeNetwork {
    
    private let path = "/notice"
    
    private let container: Container
    private var userRespository: UserRepositoriable { container.resolve() }
    private var header: [String: String] {
        let token = userRespository.getToken()
        return RequestHeader.withToken(accessToken: token)
    }
    
    public init(container: Container) {
        self.container = container
    }
    
}

extension NoticeNetwork: NoticeNetworkable {
    public func getAll(lastId: String?) async throws -> [Domain.NoticeDTO] {
        try await EndPoint
            .init(Const.baseUrl)
            .urlQueries(
                lastId != nil
                ? ["noticeId": lastId!]
                : nil
            )
            .urlPaths([self.path])
            .httpHeaders(self.header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<[NoticeDTO]>.self)
            .tryMap { try handleServerResponseResult($0) }
            .asyncThrows
    }
}
