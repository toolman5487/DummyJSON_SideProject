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
}

class ProductService:ProductServiceProtocol {

    func fetchAllProducts() -> AnyPublisher<[ProductModel], Error> {
        let url = URL(string: "https://dummyjson.com/products")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductListResponse.self, decoder: JSONDecoder())
            .map { $0.products }
            .eraseToAnyPublisher()
    }

    func fetchProduct(id: Int) -> AnyPublisher<ProductModel, Error> {
        let url = URL(string: "https://dummyjson.com/products/\(id)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct ProductListResponse: Codable {
    let products: [ProductModel]
    let total: Int
    let skip: Int
    let limit: Int
}
