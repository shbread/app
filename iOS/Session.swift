import Foundation
import Combine

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
    var selected: Int?
    var secret: Secret {
        selected
            .flatMap {
                archive.secrets.count > $0
                    ? archive.secrets[$0]
                    : nil
            }
        ?? .new
    }
    
    let modal = PassthroughSubject<App.Modal, Never>()
    
    func create() {
        if archive.available {
            modal.send(.write(.create))
        } else {
            modal.send(.purchase)
        }
    }
    
    func finish(text: String, write: App.Modal.Write) {
//        switch write {
//        case .create:
//            cloud.new(board: text.isEmpty ? "Project" : text) {
//                Notifications.send(message: "Created project")
//            }
//        case let .column(board):
//            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
//            Notifications.send(message: "Created column")
//        case let .card(board):
//            if !text.isEmpty {
//                cloud.add(board: board, card: text)
//                Notifications.send(message: "Created card")
//            }
//        case let .edit(path):
//            switch path {
//            case .board:
//                cloud.rename(board: path.board, name: text)
//                Notifications.send(message: "Renamed project")
//            case .column:
//                cloud.rename(board: path.board, column: path.column, name: text)
//                Notifications.send(message: "Renamed column")
//            case .card:
//                cloud.update(board: path.board, column: path.column, card: path.card, content: text)
//                Notifications.send(message: "Updated card")
//            }
//        }
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
            .filter { secret in
                { components in
                    components.isEmpty
                    ? true
                    : components.contains {
                        secret.1.name.localizedCaseInsensitiveContains($0)
                    }
                } (filter.search.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ").filter { !$0.isEmpty })
            }
            .map(\.0)
    }
}











struct Archive {
    let available = true
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
              tags: [.important]),
        .init(name: "Some",
              value: """
Something
""",
              date: .distantPast,
              favourite: false,
              tags: [])
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
