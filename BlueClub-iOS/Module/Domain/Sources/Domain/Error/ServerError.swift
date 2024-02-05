//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public enum ServerError: Error {
    case resultNotFound
    case unknownError
    case REQUEST_ERROR_001
    case 닉네임은_10글자_이하로_작성해주세요
    case 해당_닉네임은_중복입니다
    case 월_수입_목표는_9999만원_이하로_입력해주세요
}
