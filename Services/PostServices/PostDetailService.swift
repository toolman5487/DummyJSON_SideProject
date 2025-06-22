//
//  PostDetailService.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/22.
//

import Foundation
import Combine

protocol PostDetailServiceProtocol {
    func fetchPostDetail(id: Int) -> AnyPublisher<PostDetailModel, Error>
}

class PostDetailService: PostDetailServiceProtocol {
    func fetchPostDetail(id: Int) -> AnyPublisher<PostDetailModel, Error> {
        let url = APIConfig.baseURL.appendingPathComponent("posts/\(id)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PostDetailModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
