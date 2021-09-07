import SwiftUI
import Secrets

struct Sidebar: View {
    @Binding var search: String
    @Binding var selected: Int?
    let archive: Archive
    let new: () -> Void
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
                        Item(selected: $selected, index: $0, secret: archive.secrets[$0], tags: .init(geo.size.width / 95))
                    }
                }
                
                if !searching {
                    app
                }
                
                NavigationLink(tag: Index.full.rawValue, selection: $selected) {
                    Full(selected: $selected)
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
            
            ToolbarItem(placement: .keyboard) {
                Button(role: .cancel) {
                    UIApplication.shared.hide()
                } label: {
                    Text("Cancel")
                        .font(.footnote)
                }
                .tint(.pink)
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
            NavigationLink(tag: Index.settings.rawValue, selection: $selected) {
                Settings()
            } label: {
                Label("Settings", systemImage: "slider.horizontal.3")
            }
            
            NavigationLink(tag: Index.capacity.rawValue, selection: $selected) {
                Capacity(archive: archive)
            } label: {
                Label("Capacity", systemImage: "lock.square.stack")
            }
            
            NavigationLink(tag: Index.markdown.rawValue, selection: $selected) {
                Info(title: "Markdown", text: Copy.markdown)
            } label: {
                Label("Markdown", systemImage: "square.text.square")
            }
            
            NavigationLink(tag: Index.privacy.rawValue, selection: $selected) {
                Info(title: "Privacy policy", text: Copy.privacy)
            } label: {
                Label("Privacy policy", systemImage: "hand.raised")
            }
            
            NavigationLink(tag: Index.terms.rawValue, selection: $selected) {
                Info(title: "Terms and conditions", text: Copy.terms)
            } label: {
                Label("Terms and conditions", systemImage: "doc.plaintext")
            }
        }
        .font(.callout)
    }
}
