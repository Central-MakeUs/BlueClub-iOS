//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public enum SocialLoginError: Error {
    case appleCredentialNotFound
    case KakaoAuthNotFound
    case tokenNotFound
}
