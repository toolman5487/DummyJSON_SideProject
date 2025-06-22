//
//  PostDetailModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/22.
//

import Foundation

struct PostDetailModel: Codable {
    let id: Int
    let title: String
    let body: String
    let tags: [String]
    let reactions: Reactions
    let views: Int
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, body, tags, reactions, views
        case userId = "userId"
    }
    
    struct Reactions: Codable {
        let likes: Int
        let dislikes: Int
    }
}

