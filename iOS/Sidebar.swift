import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    
    var body: some View {
        List {
            ForEach(session.filtered, id: \.self) { index in
                NavigationLink(destination: Reveal(session: $session), isActive: .init(get: {
                    session.selected == index
                }, set: {
                    session.selected = $0 ? index : nil
                })) {
                    Item(secret: session.archive.secrets[index])
                }
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $session.filter.search)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Option(icon: session.filter.favourites ? "heart.circle.fill" : "heart") {
                    session.filter.favourites.toggle()
                }
                .font(session.filter.favourites ? .title3 : .footnote)
                .foregroundColor(session.filter.favourites ? .orange : .secondary)
            }
        }
        .navigationBarTitle("Secrets", displayMode: .large)
    }
}
