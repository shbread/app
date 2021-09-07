import StoreKit
import Secrets

extension App {
    final class Delegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, SKPaymentTransactionObserver {
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()
            
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 4) {
                    if let created = Defaults.created {
                        let days = Calendar.current.dateComponents([.day], from: created, to: .init()).day!
                        if !Defaults.rated && days > 4 {
                            SKStoreReviewController.requestReview(in: application.connectedScenes.compactMap { $0 as? UIWindowScene }.first!)
                            Defaults.rated = true
                        }
                    } else {
                        Defaults.created = .init()
                    }
                }
            
            UNUserNotificationCenter.current().delegate = self
            SKPaymentQueue.default().add(self)
            
            return true
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification) async -> UNNotificationPresentationOptions {
            let delivered = await center.deliveredNotifications()
            center.removeDeliveredNotifications(withIdentifiers: delivered
                                                    .map(\.request.identifier)
                                                    .filter {
                                                        $0 != willPresent.request.identifier
                                                    })
            return .banner
        }
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
            await cloud.notified ? .newData : .noData
        }
        
        func paymentQueue(_: SKPaymentQueue, shouldAddStorePayment: SKPayment, for: SKProduct) -> Bool {
            true
        }
        
        func paymentQueue(_: SKPaymentQueue, updatedTransactions: [SKPaymentTransaction]) {
    
        }
    }
}
