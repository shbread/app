import Foundation
import Secrets

extension Writer {
    enum Write: Equatable {
        case
        create,
        rename(Int, Secret),
        edit(Int, Secret)
    }
}
