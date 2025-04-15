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

    func loadProduct() async {
        do {
            let storeProducts = try await Product.products(for: [productId])
            self.product = storeProducts.first
        } catch {
            print("Failed to load product: \(error)")
        }
    }

    func purchase() async -> Bool {
        guard let product = product else {
            print("Product is nil")
            return false
        }

        do {
            let result = try await product.purchase()

            switch result {
            case .success(.verified):
                print("Purchase successful")
                return true
            case .success(.unverified(_, let error)):
                print("Purchase unverified: \(error.localizedDescription)")
                return false
            case .userCancelled:
                print("User cancelled")
                return false
            case .pending:
                print("Purchase pending")
                return false
            @unknown default:
                return false
            }
        } catch {
            print("Purchase error: \(error.localizedDescription)")
            return false
        }
    }
}
