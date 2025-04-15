//
//  ProductService.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 15.04.2025.
//

import Foundation
import StoreKit
import RxSwift
import RxRelay

final class ProductService {
    
    static let shared = ProductService()
    
    private let productId = "com.universe.premium.weekly"
    private let productRelay = BehaviorRelay<Product?>(value: nil)
    
    var product: Product? {
        return productRelay.value
    }
    
    var productObservable: Observable<Product?> {
        return productRelay.asObservable()
    }

    private init() {}

    func loadProduct() -> Observable<Product?> {
        Task {
            do {
                let products = try await Product.products(for: [productId])
                let firstProduct = products.first
                productRelay.accept(firstProduct)
            } catch {
                print("Failed to load product: \(error.localizedDescription)")
                productRelay.accept(nil)
            }
        }
        return productObservable
    }
}
