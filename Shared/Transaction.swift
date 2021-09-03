import Foundation
import StoreKit
import Secrets

extension Transaction {
    func process() async {
        let purchase = Purchase(rawValue: productID)!
        if revocationDate == nil {
            await cloud.add(purchase: purchase)
        } else {
            await cloud.remove(purchase: purchase)
        }
        await finish()
    }
}
