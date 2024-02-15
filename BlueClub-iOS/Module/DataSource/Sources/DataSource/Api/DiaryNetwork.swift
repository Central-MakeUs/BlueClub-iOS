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
    
    public func getDiaryById<T>(job: JobOption, id: Int) async throws -> T where T : DiaryDTO {
        let header = RequestHeader.withToken(accessToken: self.token)
        
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([
                self.path,
                "/\(id)"])
            .urlQueries([
                "job": job.queryString])
            .httpMethod(.get)
            .httpHeaders(header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<T>.self)
            .tryMap { try handleServerResponseResult($0) }
            .asyncThrows
    }
    
    public func getDiaryByDate<T: DiaryDTO>(job: JobOption, date: Date) async throws -> T where T : DiaryDTO {
        let header = RequestHeader.withToken(accessToken: self.token)
        
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([
                self.path])
            .urlQueries([
                "job": job.queryString,
                "date": formatDate(date)])
            .httpMethod(.get)
            .httpHeaders(header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<T>.self)
            .tryMap { try handleServerResponseResult($0) }
            .asyncThrows
    }
    
    
    @discardableResult public func diaryPost(
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
            .urlQueries(["job": job.queryString])
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
    
    @discardableResult public func diaryPatch(
        id: Int,
        dto: Encodable,
        job: Domain.JobOption
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
            .urlPaths([self.path, "/\(id)"])
            .httpMethod(.patch)
            .httpHeaders(header)
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
    
    public func boast(diaryId: Int) async throws -> Domain.BoastDTO {
        
        let header = RequestHeader.withToken(accessToken: self.token)
        
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([
                self.path,
                "/boast",
                "/\(diaryId)"])
            .httpHeaders(header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<BoastDTO>.self)
            .tryMap { try handleServerResponseResult($0) }
            .asyncThrows
    }
    
    
    public func list(monthIndex: Int) async throws -> [DiaryListDTO.MonthlyRecord] {
        let (year, month, _) = dateSerivce.toDayInt(monthIndex)
        let yearMonth = combineAsPath(year: year, month: month)
        let header = RequestHeader.withToken(accessToken: self.token)
        
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([self.path, "/list", "/\(yearMonth)"])
            .httpMethod(.get)
            .httpHeaders(header)
            .responseHandler { try httpResponseHandler($0) }
            .requestPublisher(expect: ServerResponse<DiaryListDTO>.self)
            .tryMap {
                try handleServerResponseCode($0)
                guard let list = $0.result?.monthlyRecord else {
                    throw ServerError.resultNotFound
                }
                return list
            }
            .asyncThrows
    }
    
    public func record() async throws -> Domain.DiaryRecordDTO {
        
        let (year, month, _) = dateSerivce.dateToInts(.now)
        let header = RequestHeader.withToken(accessToken: token)
        let yearMonth = combineAsPath(year: year, month: month)
        return try await EndPoint
            .init(Const.baseUrl)
            .urlPaths([self.path, "/record", "/\(yearMonth)"])
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

fileprivate func combineAsPath(year: Int, month: Int) -> String {
    var monthString = String(month)
    if 10 > month {
        monthString = "0" + monthString
    }
    return String(year) + "-" + monthString
}

fileprivate func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.string(from: date)
}
