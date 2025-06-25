//
//  CommentService.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/24.
//

import Foundation
import Combine

protocol CommentServiceProtocol {
    func fetchComments(for postId: Int) -> AnyPublisher<[CommentModel], Error>
}

class CommentService:CommentServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchComments(for postId: Int) -> AnyPublisher<[CommentModel], Error> {
        let url = APIConfig.baseURL.appendingPathComponent("comments/post/\(postId)")
        return session.dataTaskPublisher(for: url)
            .tryMap { data, _ in data }
            .decode(type: CommentResponse.self, decoder: JSONDecoder())
            .map { $0.comments }
            .eraseToAnyPublisher()
    }
}
