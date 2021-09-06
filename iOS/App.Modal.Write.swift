import Foundation
import Secrets

extension App.Modal {
    enum Write: Equatable {
        case
        create,
        rename(Int, Secret),
        edit(Int, Secret)
    }
}
