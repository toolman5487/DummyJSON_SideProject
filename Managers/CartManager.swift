//
//  CartManager.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/20.
//

import Foundation

class CartManager {
    
    static let shared = CartManager()
    private(set) var items: [CartItem] = []
    private init() {}
    
    func add(product: ProductModel, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            let newItem = CartItem(product: product, quantity: quantity)
            items.append(newItem)
        }
    }
    
    func remove(productId: Int) {
        items.removeAll { $0.product.id == productId }
    }
    
    func clear() {
        items.removeAll()
    }
    
    func total() -> Double {
        return items.reduce(0) { $0 + (($1.product.price ?? 0) * Double($1.quantity)) }
    }
}
