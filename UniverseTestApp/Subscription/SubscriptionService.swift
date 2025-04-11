//
//  SubscriptionService.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 10.04.2025.
//

// Subscription/SubscriptionService.swift

import StoreKit

final class SubscriptionService {

    static let shared = SubscriptionService()

    private(set) var product: Product?

    private let productId = "com.yourapp.premium.weekly"

    private init() {}

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productId])
            self.product = products.first
        } catch {
            print("Failed to load product: \(error)")
        }
    }

    func purchase() async -> Result<Transaction, Error>? {
        guard let product = product else {
            print("Product not loaded")
            return nil
        }

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    print("Purchase successful: \(transaction)")
                    return .success(transaction)
                case .unverified(_, let error):
                    print("Purchase unverified: \(error.localizedDescription)")
                    return .failure(error)
                }
            case .userCancelled:
                print("User cancelled the purchase")
                return nil
            case .pending:
                print("Purchase is pending (awaiting confirmation)")
                return nil
            @unknown default:
                print("Unknown purchase result")
                return nil
            }
        } catch {
            print("Purchase error: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    func checkSubscriptionStatus() async {
        do {
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result,
                   transaction.productID == productId {
                    print("User has active subscription: \(transaction)")
                }
            }
        } catch {
            print("Failed to check subscription status: \(error)")
        }
    }
}

