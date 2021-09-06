import SwiftUI
import Secrets

struct Sidebar: View {
    let archive: Archive
    @State private var filtered = [Int]()
    @State private var filter = Filter()
    
    var body: some View {
        GeometryReader { geo in
            if archive.secrets.isEmpty {
                Empty(archive: archive)
            } else {
                List(filtered, id: \.self) { index in
                    NavigationLink(destination: Reveal(index: index, secret: archive.secrets[index])) {
                        Item(secret: archive.secrets[index], max: .init(geo.size.width / 95))
                            .privacySensitive()
                    }
                }
                .listStyle(.sidebar)
                .searchable(text: $filter.search)
                .navigationTitle("Secrets")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Option(icon: filter.favourites ? "heart.fill" : "heart") {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        filter.favourites.toggle()
                    }
                }
                
                Option(icon: "slider.horizontal.3") {
//                    session.modal.send(.settings)
                }
                
                Option(icon: "lock.square.stack") {
//                    session.modal.send(.safe)
                }
                
                Option(icon: "plus") {
                    if archive.available {
//                        modal.send(.write(.create))
                    } else {
//                        modal.send(.full)
                    }
                }
            }
        }
        .onChange(of: filter) { _ in
            refilter()
        }
    }
    
    private func refilter() {
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
