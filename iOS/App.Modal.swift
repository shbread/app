import Foundation
import Secrets

extension App {
    enum Modal: Identifiable, Equatable {
        var id: String {
            "\(self)"
        }
        
        case
        safe,
        full,
        onboard,
        settings,
        tags(Int, Secret),
        write(Write)
    }
}
