//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Domain
import MightyCombine

public struct DiaryNetwork: DiaryNetworkable {
    
    private let path = "/diary"
    private let dateSerivce: DateServiceable
    private let userRespository: UserRepositoriable
    private var token: String {
        userRespository.getToken()
    }
    
    public init(
        userRespository: UserRepositoriable,
        dateSerivce: DateServiceable = DateService()
    ) {
        self.userRespository = userRespository
        self.dateSerivce = dateSerivce
    }
    
    public func diary(_ dto: Domain.DiaryDTO) async throws {
        
    }
    
    public func record() async throws -> Domain.DiaryRecordDTO {
        
        let (year, month, _) = dateSerivce.dateToInts(.now)
        var monthString = String(month)
        let header = RequestHeader.withToken(accessToken: token)
        if 10 > month {
            monthString = "0" + monthString
        }
        let datePath = "/\(year)-" + monthString
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([self.path, "/record", datePath])
            .httpMethod(.get)
            .httpHeaders(header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<DiaryRecordDTO>.self)
            .tryMap { try handleServerResponseResult($0) }
            .asyncThrows
    }
}
