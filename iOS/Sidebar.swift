import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    
    var body: some View {
        GeometryReader { geo in
            if session.archive.secrets.isEmpty {
                Empty(session: $session)
            } else {
                List(session.filtered, id: \.self) { index in
                    NavigationLink(destination: Reveal(session: $session), isActive: .init(get: {
                        session.selected == index
                    }, set: {
                        session.selected = $0 ? index : nil
                    })) {
                        Item(secret: session.archive.secrets[index], max: .init(geo.size.width / 95))
                    }
                }
                .privacySensitive()
                .listStyle(.sidebar)
                .searchable(text: $session.filter.search)
                .navigationBarTitle("Secrets", displayMode: .large)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Option(icon: session.filter.favourites ? "heart.fill" : "heart") {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        session.filter.favourites.toggle()
                    }
                }
                
                Option(icon: "slider.horizontal.3") {
                    session.modal.send(.settings)
                }
                
                Option(icon: "lock.square.stack") {
                    session.modal.send(.safe)
                }
                
                Option(icon: "plus", action: session.create)
            }
        }
    }
}
