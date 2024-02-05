//
//  File.swift
//  
//
//  Created by 김인섭 on 2/6/24.
//

import Foundation

public struct AuthDTO: Codable {
    
    public var id: Int
    public var email: String?
    public var name: String?
    public var nickname: String
    public var profileImage: String?
    public var job: String?
    public var monthlyTargetIncome: Int?
    public var role: String
    public var socialType: String?
    public var socialId: String?
    
    public var accessToken: String
    public var refreshToken: String
    
    public init(id: Int, email: String?, name: String?, nickname: String, profileImage: String?, job: String?, monthlyTargetIncome: Int?, role: String, socialType: String?, socialId: String?, accessToken: String, refreshToken: String) {
        self.id = id
        self.email = email
        self.name = name
        self.nickname = nickname
        self.profileImage = profileImage
        self.job = job
        self.monthlyTargetIncome = monthlyTargetIncome
        self.role = role
        self.socialType = socialType
        self.socialId = socialId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
