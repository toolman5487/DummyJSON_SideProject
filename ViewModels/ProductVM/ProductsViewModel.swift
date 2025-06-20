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
        productService.fetchAllProductsPaginated(pageSize: 200)
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
    
    func fetchRandomProducts(count: Int) {
        productService.fetchAllProductsPaginated(pageSize: 200)
            .map { products in
                Array(products.shuffled().prefix(count))
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] randomProducts in
                self?.products = randomProducts
            })
            .store(in: &cancellables)
    }
    
}
