//
//  ProductsViewModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/19.
//

import Foundation
import Combine

class ProductsViewModel {
    
    @Published var products: [ProductModel] = []
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private let productService: ProductServiceProtocol
    
    init(service: ProductServiceProtocol = ProductService()) {
        self.productService = service
    }
    
    func fetchProducts() {
        productService.fetchAllProducts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancellables)
    }
}
