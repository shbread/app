import Foundation
import Secrets

extension Writer {
    enum Write: Equatable {
        case
        create,
        edit(Int, Secret)
    }
}
