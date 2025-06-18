//
//  UserModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/18.
//

import Foundation

struct UserModel: Codable {
    let id: Int
    let username: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username, email
        case firstName = "firstName"
        case lastName = "lastName"
        case gender, image
    }
}
