import SwiftUI
import Secrets

struct Sidebar: View {
    let archive: Archive
    @State private var filtered = [Int]()
    @State private var favourites = false
    @State private var search = ""
    
    var body: some View {
        GeometryReader { geo in
            if archive.secrets.isEmpty {
                Empty(archive: archive)
            } else {
                List {
                    Section("Secrets") {
                        ForEach(filtered, id: \.self) { index in
                            NavigationLink(destination: Reveal(index: index, secret: archive.secrets[index])) {
                                Item(secret: archive.secrets[index], max: .init(geo.size.width / 95))
                                    .privacySensitive()
                            }
                        }
                    }
                    Section("Other") {
                        NavigationLink("Settings", destination: Settings())
                    }
                }
                .listStyle(.sidebar)
                .searchable(text: $search)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Option(icon: favourites ? "heart.fill" : "heart") {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        favourites.toggle()
                    }
                }
                
                Option(icon: "slider.horizontal.3") {
//                    session.modal.send(.settings)
                }
                
                Option(icon: "lock.square.stack") {
//                    session.modal.send(.safe)
                }
                
                NavigationLink(destination: Writer(write: .create)) {
                    Image(systemName: "plus")
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 50, height: 36)
                        .contentShape(Rectangle())
                }
//                Option(icon: "plus") {
//                    if archive.available {
////                        modal.send(.write(.create))
//                    } else {
////                        modal.send(.full)
//                    }
//                }
            }
        }
        .onChange(of: archive) {
            update(secrets: $0.secrets, favourites: favourites, search: search)
        }
        .onChange(of: favourites) {
            update(secrets: archive.secrets, favourites: $0, search: search)
        }
        .onChange(of: search) {
            update(secrets: archive.secrets, favourites: favourites, search: $0)
        }
    }
    
    private func update(secrets: [Secret], favourites: Bool, search: String) {
        filtered = secrets
            .enumerated()
            .filter {
                favourites
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
                } (search
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: " ")
                    .filter {
                        !$0.isEmpty
                    })
            }
            .map(\.0)
    }
}
