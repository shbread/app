import Foundation

extension App {
    enum Write: Equatable {
        case
        create,
        edit(Int)
    }
}
