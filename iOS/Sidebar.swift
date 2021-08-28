import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    @State private var filter = ""
    
    var body: some View {
        List {
            ForEach(0 ..< session.archive.filtered.count, id: \.self) { index in
                NavigationLink(destination: Reveal(session: $session, index: index)) {
                    Item(secret: session[index])
                }
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $filter)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "lock.square.stack")
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "heart.fill")
                }
            }
        }
        .navigationBarTitle("Secrets", displayMode: .large)
    }
}
