//
//  PaywallViewModel.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 15.04.2025.
//

import Foundation
import StoreKit

final class PaywallViewModel {
    private let productId = "com.universe.premium.weekly"
    private(set) var product: Product?

    func loadProduct(completion: @escaping (Product?) -> Void) {
        Task {
            do {
                let products = try await Product.products(for: [productId])
                self.product = products.first
                completion(products.first)
            } catch {
                print("Error loading product: \(error)")
                completion(nil)
            }
        }
    }

    func purchase(completion: @escaping (Bool) -> Void) {
        guard let product = product else {
            completion(false)
            return
        }

        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(.verified(_)):
                    completion(true)
                default:
                    completion(false)
                }
            } catch {
                print("Purchase failed: \(error)")
                completion(false)
            }
        }
    }
}
