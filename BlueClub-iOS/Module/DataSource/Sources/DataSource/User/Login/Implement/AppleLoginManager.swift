//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Domain
import AuthenticationServices

public class AppleLoginManager: NSObject, AppleLoginRequestable {
    
    private var continuation: CheckedContinuation<SocialLoginUserInfo, Error>?
    
    public override init() { super.init() }
    
    public lazy var request: () async throws -> Domain.SocialLoginUserInfo = {
        try await withCheckedThrowingContinuation { continuation in
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
            self.continuation = continuation
        }
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: SocialLoginError.invalidCredential)
            return
        }

        guard let tokenData = credential.identityToken,
              let token = String(data: tokenData, encoding: .utf8) else {
            continuation?.resume(throwing: SocialLoginError.tokenNotFound)
            return
        }
        
        let id = credential.user
        let email = credential.email
        var name: String?
        let familyName = credential.fullName?.familyName
        let givenName = credential.fullName?.givenName
        
        if let familyName, let givenName {
            name = familyName + givenName
        }
        
        let userInfo = SocialLoginUserInfo(
            id: id,
            token: token,
            name: name,
            email: email,
            loginMethod: .apple
        )
        
        continuation?.resume(returning: userInfo)
    }

    // Delegate method called when the authorization fails
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        continuation?.resume(throwing: error)
    }
}
