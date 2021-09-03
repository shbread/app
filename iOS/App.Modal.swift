import Foundation

extension App {
    enum Modal: Identifiable, Equatable {
        var id: String {
            "\(self)"
        }
        
        case
        safe,
        full,
        tags,
        onboard,
        write(Write)
    }
}
