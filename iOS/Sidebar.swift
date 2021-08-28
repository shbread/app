import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    
    var body: some View {
        List {
            ForEach(session.filtered, id: \.self) { index in
                NavigationLink(destination: Reveal(session: $session, index: index)) {
                    Item(secret: session[index])
                }
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $session.filter.search)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Option(icon: "slider.horizontal.3") {
                    
                }
                
                Spacer()
                
                Option(icon: "plus.circle.fill") {
                    
                }
                .font(.title)
                
                Spacer()
                
                Option(icon: "lock.square.stack") {
                    
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Option(icon: session.filter.favourites ? "heart.circle.fill" : "heart.circle") {
                    session.filter.favourites.toggle()
                }
                .font(.title3)
                .foregroundStyle(session.filter.favourites ? .primary : .secondary)
            }
        }
        .navigationBarTitle("Secrets", displayMode: .large)
    }
}
