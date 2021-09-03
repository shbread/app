import StoreKit
import Combine

struct Store {
    let state = CurrentValueSubject<State, Never>(.loading)
    
    @MainActor func load() async {
        do {
            let products = try await Product.products(for: Purchase.allCases.map(\.id))
            state.send(.products(products
                                    .sorted {
                $0.price < $1.price
            }))
        } catch let error {
            state.send(.error("Unable to connect to the App Store.\n" + error.localizedDescription))
        }
    }
    
    /*
    let products = CurrentValueSubject<[(product: SKProduct, price: String)], Never>([])
    let loading = CurrentValueSubject<Bool, Never>(true)
    let error = CurrentValueSubject<String?, Never>(nil)
    let open = PassthroughSubject<Void, Never>()
    private weak var request: SKProductsRequest?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func load() {
        request?.cancel()
        error.value = nil

        guard products.value.isEmpty else { return }
        loading.value = true
        
        let request = SKProductsRequest(productIdentifiers: .init(Item.allCases.map(\.rawValue)))
        request.delegate = self
        self.request = request
        request.start()
    }
    
    func purchase(_ product: SKProduct) {
        DispatchQueue.main.async {
            self.loading.value = true
            SKPaymentQueue.default().add(.init(product: product))
        }
    }
    
    func paymentQueue(_: SKPaymentQueue, updatedTransactions: [SKPaymentTransaction]) {
        guard !updatedTransactions.contains(where: { $0.transactionState == .purchasing }) else { return }
        updatedTransactions
            .forEach { transaction in
                switch transaction.transactionState {
                case .failed:
                    if (transaction.error as? SKError)?.code != SKError.paymentCancelled {
                        DispatchQueue.main.async {
                            self.error.value = "There was an error connecting to the App Store, please try again later."
                        }
                    }
                case .purchased, .restored:
                    DispatchQueue.main.async {
                        switch Item(rawValue: transaction.payment.productIdentifier)! {
                        case .plus_one:
                            cloud.purschase()
                        }
                    }
                default: break
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        DispatchQueue.main.async {
            self.loading.value = false
        }
    }
    
    func paymentQueue(_: SKPaymentQueue, shouldAddStorePayment: SKPayment, for: SKProduct) -> Bool {
        open.send()
        return true
    }
    
    func request(_: SKRequest, didFailWithError: Error) {
        DispatchQueue.main.async {
            self.error.value = didFailWithError.localizedDescription
        }
    }
    
    func productsRequest(_: SKProductsRequest, didReceive: SKProductsResponse) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyISOCode
        
        DispatchQueue.main.async {
            self.products.value = didReceive.products
                .sorted { $0.price.doubleValue < $1.price.doubleValue }
                .map {
                    formatter.locale = $0.priceLocale
                    return (product: $0, price: formatter.string(from: $0.price)!)
                }
            self.loading.value = false
            self.error.value = nil
        }
    }
    
    func paymentQueue(_: SKPaymentQueue, restoreCompletedTransactionsFailedWithError: Error) {
        DispatchQueue.main.async {
            self.error.value = restoreCompletedTransactionsFailedWithError.localizedDescription
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_: SKPaymentQueue) {
        DispatchQueue.main.async {
            self.loading.value = false
        }
    }
    
    @objc func restore() {
        loading.value = true
        error.value = nil
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
     */
}
