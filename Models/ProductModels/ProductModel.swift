//
//  ProductModel.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/19.
//

import Foundation

struct ProductModel: Codable {
    let id: Int
    let title: String
    let description: String?
    let category: String?
    let price: Double?
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let tags: [String]?
    let brand: String?
    let sku: String?
    let weight: Double?
    let dimensions: Dimensions?
    let warrantyInformation: String?
    let shippingInformation: String?
    let availabilityStatus: String?
    let reviews: [ProductReview]?
    let returnPolicy: String?
    let minimumOrderQuantity: Int?
    let meta: ProductMeta?
    let thumbnail: String?
    let images: [String]?
}

struct Dimensions: Codable {
    let width: Double?
    let height: Double?
    let depth: Double?
}

struct ProductReview: Codable {
    let rating: Int?
    let comment: String?
    let date: String?
    let reviewerName: String?
    let reviewerEmail: String?
}

struct ProductMeta: Codable {
    let createdAt: String?
    let updatedAt: String?
    let barcode: String?
    let qrCode: String?
}
