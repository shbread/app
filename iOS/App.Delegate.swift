import UIKit
import UserNotifications
import StoreKit
import Combine
import Secrets

extension App {
    final class Delegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        private var subs = Set<AnyCancellable>()
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()

//            DispatchQueue
//                .main
//                .asyncAfter(deadline: .now() + 3) {
//                    if let created = Defaults.created {
//                        let days = Calendar.current.dateComponents([.day], from: created, to: .init()).day!
//                        if !Defaults.rated && days > 4 {
//                            SKStoreReviewController.requestReview(in: application.connectedScenes.compactMap { $0 as? UIWindowScene }.first!)
//                            Defaults.rated = true
//                        }
//                    } else {
//                        Defaults.created = .init()
//                    }
//                }
            
            UNUserNotificationCenter.current().delegate = self
            
            return true
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification, withCompletionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            center
                .getDeliveredNotifications {
                    center
                        .removeDeliveredNotifications(withIdentifiers: $0
                                                        .map(\.request.identifier)
                                                        .filter {
                                                            $0 != willPresent.request.identifier
                                                        })
                }
            
            withCompletionHandler([.banner])
        }
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            Task {
                fetchCompletionHandler(await cloud.notified ? .newData : .noData)   
            }
        }
    }
}
