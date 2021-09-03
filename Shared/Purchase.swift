import Foundation

enum Purchase: String, CaseIterable {
    case
    one = "shortbread.1",
    five = "shortbread.5",
    ten = "shortbread.10"
    
    var save: Int {
        switch self {
        case .one:
            return 0
        case .five:
            return 40
        case .ten:
            return 50
        }
    }
}
