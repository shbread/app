import SwiftUI
import Secrets

struct Sidebar: View {
    @Binding var search: String
    @Binding var create: Bool
    @Binding var full: Bool
    let archive: Archive
    let new: () -> Void
    @State private var capacity = false
    @State private var onboard = false
    @State private var favourites = false
    @State private var filtered = [Int]()
    @Environment(\.isSearching) var searching
    
    var body: some View {
        GeometryReader { geo in
            List {
                if !searching {
                    add
                }
                
                Section("Secrets") {
                    ForEach(filtered, id: \.self) {
                        Item(index: $0, secret: archive.secrets[$0], tags: .init(geo.size.width / 95))
                    }
                }
                
                if !searching {
                    app
                }
                
                NavigationLink(isActive: $full) {
                    Full(capacity: $capacity)
                } label: {
                    
                }
                .hidden()
                
                NavigationLink(isActive: $create) {
                    Reveal(index: archive.secrets.count - 1, secret: archive.secrets.last!, edit: true)
                } label: {
                    
                }
                .hidden()
            }
            .listStyle(.sidebar)
            .symbolRenderingMode(.hierarchical)
            .navigationBarTitleDisplayMode(.inline)
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
            }
        }
        .sheet(isPresented: $onboard, content: Onboard.init)
        .onAppear {
            if !Defaults.onboarded {
                onboard = true
            }
            filtered = archive.secrets.filter(favourites: favourites, search: search)
        }
        .onChange(of: archive) {
            filtered = $0.secrets.filter(favourites: favourites, search: search)
        }
        .onChange(of: favourites) {
            filtered = archive.secrets.filter(favourites: $0, search: search)
        }
        .onChange(of: search) {
            filtered = archive.secrets.filter(favourites: favourites, search: $0)
        }
    }
    
    private var add: some View {
        HStack {
            Spacer()
            Button(action: new) {
                Label("New secret", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .listItemTint(.white)
        .listRowBackground(Color.clear)
    }
    
    private var app: some View {
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
