//
//  LoginResponse.swift
//  SocialAppTest
//
//  Created by AsherFelix on 19/08/2023.
//

import Foundation
import ObjectMapper
struct LoginResponse: Decodable {
    var userId: String?
    var accessToken: String?
    var refreshToken: String?
    
    enum Codingkeys: String, CodingKey {
        case userId = "user_id"
        case accessToken = "access_token"
        case refeshToken = "refresh_token"
    }
}
class LoginResponseByManual {
    var userId: String?
    var accessToken: String?
    var refreshToken: String?
    
    init(userId: String? = nil,
         accessToken: String? = nil,
         refreshToken: String? = nil) {
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
class loginResByObjectMapper: Mappable {
    var userId: String?
    var accessToken: String?
    var refreshToken: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        userId    <- map["username"]
        accessToken         <- map["access_Token"]
        refreshToken      <- map["refresh_Token"]
    }
}
