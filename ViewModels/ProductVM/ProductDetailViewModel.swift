//
//  ProductDetailViewModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/19.
//


import Foundation
import Combine

class ProductDetailViewModel {
    
    @Published var product: ProductModel?
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private let productService: ProductServiceProtocol

    init(service: ProductServiceProtocol = ProductService()) {
        self.productService = service
    }

    func fetchProduct(id: Int) {
        productService.fetchProduct(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] product in
                self?.product = product
            })
            .store(in: &cancellables)
    }
}
