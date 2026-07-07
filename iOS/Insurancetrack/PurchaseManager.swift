import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published var isPurchased: Bool = false
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false

    static let productID = "com.shimondeitel.insurancetrack.pro.monthly"

    private var updatesTask: Task<Void, Never>? = nil

    init() {
        updatesTask = listenForTransactions()
        Task { await loadProducts(); await refreshEntitlements() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await Product.products(for: [Self.productID])
        } catch {
            products = []
        }
    }

    func purchase() async {
        guard let product = products.first else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    isPurchased = true
                }
            default:
                break
            }
        } catch {
            // purchase failed or cancelled
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.productID {
                isPurchased = true
                return
            }
        }
        isPurchased = false
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await self?.refreshEntitlements()
                }
            }
        }
    }
}
