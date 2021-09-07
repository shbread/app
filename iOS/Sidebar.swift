import SwiftUI
import Secrets

struct Sidebar: View {
    @Binding var search: String
    let archive: Archive
    @State private var capacity = false
    @State private var onboard = false
    @State private var filtered = [Int]()
    @State private var favourites = false
    @Environment(\.isSearching) var searching
    
    var body: some View {
        GeometryReader { geo in
            List {
                if !searching {
                    NavigationLink {
                        if archive.available {
                            Writer(write: .create)
                        } else {
                            Full(capacity: $capacity)
                        }
                    } label: {
                        Label("New secret", systemImage: "plus")
                    }
                }
                
                Section("Secrets") {
                    ForEach(filtered, id: \.self) { index in
                        NavigationLink(destination: Reveal(index: index, secret: archive.secrets[index])) {
                            Item(secret: archive.secrets[index], max: .init(geo.size.width / 95))
                                .privacySensitive()
                        }
                    }
                }
                
                if !searching {
                    Section("App") {
                        NavigationLink(destination: Settings()) {
                            Label("Settings", systemImage: "slider.horizontal.3")
                        }
                        
                        NavigationLink(isActive: $capacity) {
                            Capacity(archive: archive)
                        } label: {
                            Label("Capacity", systemImage: "lock.square.stack")
                        }
                        
                        NavigationLink(destination: Info(title: "Markdown", text: Copy.markdown)) {
                            Label("Markdown", systemImage: "square.text.square")
                        }
                        
                        NavigationLink(destination: Info(title: "Privacy policy", text: Copy.privacy)) {
                            Label("Privacy policy", systemImage: "hand.raised")
                        }
                        
                        NavigationLink(destination: Info(title: "Terms and conditions", text: Copy.terms)) {
                            Label("Terms and conditions", systemImage: "doc.plaintext")
                        }
                    }
                    .font(.callout)
                }
            }
            .listStyle(.sidebar)
            .symbolRenderingMode(.hierarchical)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        favourites.toggle()
                    }
                } label: {
                    Image(systemName: favourites ? "heart.fill" : "heart")
                        .symbolRenderingMode(.hierarchical)
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
        .sheet(isPresented: $onboard, content: Onboard.init)
        .onAppear {
            if !Defaults.onboarded {
                onboard = true
            }
            update(secrets: archive.secrets, favourites: favourites, search: search)
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
