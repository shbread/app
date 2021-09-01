import Foundation
import Combine
import Secrets

struct Session {
    var archive = Archive.new {
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
    
    func finish(text: String, write: App.Modal.Write) async {
        switch write {
        case .create:
            await cloud.new(secret: text)
//            cloud.new(board: text.isEmpty ? "Project" : text) {
//                Notifications.send(message: "Created project")
//            }
        case .edit:
            break
//            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
//            Notifications.send(message: "Created column")
        }
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
                } (filter
                    .search
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: " ")
                    .filter {
                        !$0.isEmpty
                    })
            }
            .map(\.0)
    }
}
