import Foundation
import Combine
import Secrets

struct Session {
    var archive = Archive.new
    
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
