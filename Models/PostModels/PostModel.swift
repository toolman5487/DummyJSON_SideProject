//
//  PostModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/21.
//

import Foundation

// MARK: - PostModel
struct PostModel: Codable {
    let posts: [Post]
    let total, skip, limit: Int
}

// MARK: - Post
struct Post: Codable {
    let id: Int
    let title, body: String
    let tags: [String]
    let reactions: Reactions
    let views, userID: Int

    enum CodingKeys: String, CodingKey {
        case id, title, body, tags, reactions, views
        case userID = "userId"
    }
}

// MARK: - Reactions
struct Reactions: Codable {
    let likes, dislikes: Int
}
