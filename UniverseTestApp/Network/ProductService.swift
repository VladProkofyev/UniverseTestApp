//
//  ProductService.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 09.04.2025.
//

import Foundation
import StoreKit

final class ProductService: ObservableObject {
    static let shared = ProductService()
    @Published var product: Product?

    private let productId = "com.universe.premium.weekly"

    func loadProduct() async {
        do {
            let storeProducts = try await Product.products(for: [productId])
            self.product = storeProducts.first
        } catch {
            print("Failed to load product: \(error)")
        }
    }

    func purchase() async -> Bool {
        guard let product = product else { return false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(.verified(_)):
                print("Purchase successful")
                return true
            case .success(.unverified(_, _)):
                print("Purchase unverified")
                return false
            case .userCancelled:
                print("User cancelled")
                return false
            default:
                return false
            }
        } catch {
            print("Purchase error: \(error)")
            return false
        }
    }
}
