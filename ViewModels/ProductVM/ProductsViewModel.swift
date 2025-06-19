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
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancellables)
    }
    
    func fetchProductPage(limit: Int = 30, skip: Int = 0) {
        productService.fetchProductPage(limit: limit, skip: skip)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                self?.products = response.products.shuffled()
            })
            .store(in: &cancellables)
    }
}
