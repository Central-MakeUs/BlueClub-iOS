//
//  File.swift
//  
//
//  Created by 김인섭 on 1/13/24.
//

import KakaoSDKUser
import Domain

public class KakaoLoginService: KakaoLoginServiceable {

    private var continuation: CheckedContinuation<SocialLoginUser, Error>?
    
    public lazy var request: () async throws -> Domain.SocialLoginUser = {
        try await withCheckedThrowingContinuation { continuation in
            let hasKakaoTalk = UserApi.isKakaoTalkLoginAvailable()
            if hasKakaoTalk {
                UserApi.shared.loginWithKakaoTalk { auth, error in
                    if let error { continuation.resume(throwing: error) }
                    guard let auth else {
                        return continuation.resume(throwing: SocialLoginError.KakaoAuthNotFound)
                    }
                    
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { auth, error in
                    if let error { continuation.resume(throwing: error) }
                    guard let auth else {
                        return continuation.resume(throwing: SocialLoginError.KakaoAuthNotFound)
                    }
                }
            }
            self.continuation = continuation
        }
    }
}
