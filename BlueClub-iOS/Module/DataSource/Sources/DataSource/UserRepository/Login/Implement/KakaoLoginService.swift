//
//  File.swift
//  
//
//  Created by 김인섭 on 1/13/24.
//

import KakaoSDKUser
import Domain

public class KakaoLoginService: KakaoLoginServiceable {
    
    public init() { }

    private var continuation: CheckedContinuation<SocialLoginUser, Error>?
    
    public lazy var request: () async throws -> Domain.SocialLoginUser = {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            let hasKakaoTalk = UserApi.isKakaoTalkLoginAvailable()
            if hasKakaoTalk {
                UserApi.shared.loginWithKakaoTalk { auth, error in
                    if let error { continuation.resume(throwing: error) }
                    guard let auth else {
                        return continuation.resume(throwing: SocialLoginError.kakaoAuthNotFound)
                    }
                    self?.requestUserData()
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { auth, error in
                    if let error { continuation.resume(throwing: error) }
                    guard let auth else {
                        return continuation.resume(throwing: SocialLoginError.kakaoAuthNotFound)
                    }
                    self?.requestUserData()
                }
            }
            self?.continuation = continuation
        }
    }
    
    private func requestUserData() {
        UserApi.shared.me { [weak self] user, error in
            if let error { self?.continuation?.resume(throwing: error) }
            guard let user, let id = user.id else {
                self?.continuation?.resume(throwing: SocialLoginError.kakaoUserNotFoun)
                return
            }
            let loginUser = SocialLoginUser(
                id: String(id),
                name: user.kakaoAccount?.legalName,
                email: user.kakaoAccount?.email,
                loginMethod: .kakao)
            self?.continuation?.resume(returning: loginUser)
        }
    }
}
