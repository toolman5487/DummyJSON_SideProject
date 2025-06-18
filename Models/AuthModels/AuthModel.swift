//
//  AuthModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let id: Int
    let username: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
        case id, username, email, firstName, lastName, gender, image
    }
}
