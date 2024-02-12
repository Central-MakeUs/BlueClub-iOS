//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation
import Domain
import MightyCombine

public struct DiaryNetwork {
    
    private let path = "/diary"
    private let dateSerivce: DateServiceable
    private let userRespository: UserRepositoriable
    private var token: String {
        userRespository.getToken()
    }
    private var multiPartHeader: [String: String] {
        RequestHeader.multiPartWithToken(accessToken: self.token)
    }
    
    public init(
        userRespository: UserRepositoriable,
        dateSerivce: DateServiceable = DateService()
    ) {
        self.userRespository = userRespository
        self.dateSerivce = dateSerivce
    }
}

extension DiaryNetwork: DiaryNetworkable {

    @discardableResult
    public func diary(
        _ dto: Encodable,
        job: JobOption
    ) async throws -> Int {

        let encoded = try JSONEncoder().encode(dto)
        let dtoString = String(data: encoded, encoding: .utf8)!
        
        let formData = MultiPartFormData()
        let bodyData = formData.bodyData(
            data: Data(dtoString.utf8),
            parameters: [:],
            name: "dto",
            filename: "dto.json",
            mimeType: "application/json")
        
        var header = self.multiPartHeader
        header["Content-Type"] = formData.headers["Content-Type"]
        
        return try await EndPoint
            .init(Const.baseUrl)
            .urlQueries(["job": job.title])
            .urlPaths([self.path])
            .httpHeaders(header)
            .httpMethod(.post)
            .responseHandler { try httpResponseHandler($0) }
            .uploadPublisher(
                from: bodyData,
                expect: ServerResponse<ResponseResult>.self)
            .tryMap {
                try handleServerResponseCode($0)
                guard let id = $0.result?.id else {
                    throw ServerError.resultNotFound
                }
                return id
            }
            .asyncThrows
    }
    
    @discardableResult
    public func diaryDayOff(date: String) async throws -> Int {
        let dtoString = """
        {
            "worktype": "휴무",
            "date": \(date)
        }
        """
        
        return try await EndPoint
            .init(Const.baseUrl)
            .urlQueries(["job": JobOption.dayWorker.title])
            .urlPaths([self.path])
            .httpHeaders(multiPartHeader)
            .httpMethod(.post)
            .httpBody([
                "dto": dtoString
            ])
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<Int>.self)
            .tryMap { try handleServerResponseResult($0) }
            .asyncThrows
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

fileprivate struct ResponseResult: Codable {
    let id: Int
}
