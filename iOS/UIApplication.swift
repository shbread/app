import Foundation
import UIKit

extension UIApplication {
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
}
