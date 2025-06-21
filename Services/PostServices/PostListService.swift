//
//  PostListService.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/21.
//


import Foundation
import Combine

protocol PostServiceProtocol {
    func fetchPosts(limit: Int, skip: Int) -> AnyPublisher<PostModel, Error>
}

class PostService: PostServiceProtocol {
    
    func fetchPosts(limit: Int = 30, skip: Int = 0) -> AnyPublisher<PostModel, Error> {
        var components = URLComponents(url: APIConfig.baseURL.appendingPathComponent("posts"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)")
        ]
        guard let url = components?.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PostModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
