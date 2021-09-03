import StoreKit
import Combine
import Secrets

struct Store {
    let state = CurrentValueSubject<State, Never>(.loading)
    
    init() {
        Task
            .detached {
                for await result in Transaction.updates {
                    if case let .verified(safe) = result {
                        await safe.process()
                        // Notification.transaction
                    }
                }
            }
    }
    
    @MainActor func load() async {
        do {
            let products = try await Product.products(for: Purchase.allCases.map(\.rawValue))
            state.send(
                .products(
                    products
                        .sorted {
                            $0.price < $1.price
                        }))
        } catch let error {
            state.send(.error("Unable to connect to the App Store.\n" + error.localizedDescription))
        }
    }
    
    @MainActor func purchase(_ product: Product) async {
        state.send(.loading)
        
        do {
            switch try await product.purchase() {
            case let .success(verification):
                if case let .verified(safe) = verification {
                    await safe.process()
                    await load()
                    // Notification.transaction
                } else {
                    state.send(.error("Purchase verification failed."))
                }
            case .pending:
                await load()
                // Notification pending
            default:
                await load()
            }
        } catch let error {
            state.send(.error(error.localizedDescription))
        }
    }
}
