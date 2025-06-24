//
//  CommentModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/24.
//

import Foundation

struct CommentModel: Codable {
    let id: Int
    let body: String
    let postId: Int
    let likes: Int
    let user: CommentUser
}

struct CommentUser: Codable {
    let id: Int
    let username: String
    let fullName: String
}

struct CommentResponse: Codable {
    let comments: [CommentModel]
    let total: Int
    let skip: Int
    let limit: Int
}

