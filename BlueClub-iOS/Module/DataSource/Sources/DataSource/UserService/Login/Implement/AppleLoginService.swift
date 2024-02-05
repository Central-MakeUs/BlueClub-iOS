//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Domain
import AuthenticationServices

public class AppleLoginService: NSObject, AppleLoginServiceable {
    
    private var continuation: CheckedContinuation<SocialLoginUser, Error>?
    
    public override init() { super.init() }
    
    public lazy var request: () async throws -> Domain.SocialLoginUser = {
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

extension AppleLoginService: ASAuthorizationControllerDelegate {

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: SocialLoginError.appleCredentialNotFound)
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
        

        let userInfo = SocialLoginUser(
            id: id,
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
