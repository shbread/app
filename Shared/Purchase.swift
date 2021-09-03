import Foundation

enum Purchase: Int, CaseIterable {
    case
    one = 1,
    five = 5,
    ten = 10
    
    var id: String {
        "shortbread.\(rawValue)"
    }
}
