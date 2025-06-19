//
//  ProductService.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/19.
//

import Foundation
import Combine

protocol ProductServiceProtocol {
    func fetchAllProducts() -> AnyPublisher<[ProductModel], Error>
    func fetchProduct(id: Int) -> AnyPublisher<ProductModel, Error>
    func fetchProductPage(limit: Int, skip: Int) -> AnyPublisher<ProductListResponse, Error>
}

class ProductService:ProductServiceProtocol {
    
    func fetchAllProducts() -> AnyPublisher<[ProductModel], Error> {
        let url = APIConfig.baseURL.appendingPathComponent("products")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductListResponse.self, decoder: JSONDecoder())
            .map { $0.products }
            .eraseToAnyPublisher()
    }
    
    func fetchProduct(id: Int) -> AnyPublisher<ProductModel, Error> {
        let url = APIConfig.baseURL.appendingPathComponent("products/\(id)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchProductPage(limit: Int, skip: Int) -> AnyPublisher<ProductListResponse, Error> {
        var components = URLComponents(url: APIConfig.baseURL.appendingPathComponent("products"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)")
        ]
        let url = components.url!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductListResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct ProductListResponse: Codable {
    let products: [ProductModel]
    let total: Int
    let skip: Int
    let limit: Int
}
