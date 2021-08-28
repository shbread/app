import Foundation

struct Session {
    var archive = Archive() {
        didSet {
            refilter()
        }
    }
    
    var filter = Filter() {
        didSet {
            refilter()
        }
    }
    
    var filtered = [Int]()
    
    subscript(_ index: Int) -> Secret {
        archive.secrets.count > index
            ? archive.secrets[index]
            : .new
    }
    
    private mutating func refilter() {
        filtered = archive
            .secrets
            .enumerated()
            .filter {
                filter.favourites
                ? $0.1.favourite
                : true
            }
            .map(\.0)
    }
}











struct Archive {
    let secrets: [Secret] = [
        .init(name: "Shortbread recipe",
              value: """
- Water
- Sugar
- Butter
- Ginger

Mix ginger with butter...
""",
              date: .init(timeIntervalSinceNow: -1000),
              favourite: true,
              tags: [.family, .top]),
        .init(name: "Hidden shortbread stash",
              value: """
On the left cubboard under the sink in the kitchen, behind the paper towels.
""",
              date: .init(timeIntervalSinceNow: -500),
              favourite: false,
              tags: [.home]),
        .init(name: "Who is the person on the picture",
              value: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
""",
              date: .init(timeIntervalSinceNow: -2500),
              favourite: false,
              tags: []),
        .init(name: "The meaning of life",
              value: """
42
""",
              date: .distantPast,
              favourite: true,
              tags: [.important])
    ]
}

struct Secret {
    static let new = Self(name: "", value: "", date: .init(), favourite: false, tags: [])
    
    let name: String
    let value: String
    let date: Date
    let favourite: Bool
    let tags: [Tag]
}

enum Tag: CaseIterable {
    case
    home,
    office,
    work,
    family,
    important,
    top,
    partner,
    critical,
    fun,
    school,
    utilities,
    other,
    security
}