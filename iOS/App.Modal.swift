import Foundation

extension App {
    enum Modal: Identifiable, Equatable {
        var id: String {
            "\(self)"
        }
        
        case
        safe,
        purchase,
        tags,
        write(Write)
    }
}
