import SwiftUI

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @State private var modal: Modal?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar(session: $session)
            }
            .navigationViewStyle(.columns)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    if session.selected == nil {
                        Option(icon: "slider.horizontal.3") {
                            
                        }
                        
                        Spacer()
                        
                        Option(icon: "plus.circle.fill", action: session.create)
                            .font(.title)
                        
                        Spacer()
                        
                        Option(icon: "lock.square.stack") {
                            session.modal.send(.safe)
                        }
                    } else {
                        Option(icon: "trash.square.fill") {

                        }
                        .font(.title3)
                        .foregroundStyle(.secondary)

                        Option(icon: "doc.on.doc.fill") {

                        }
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                        Spacer()
                        
                        Option(icon: "pencil.circle.fill") {
                            session.modal.send(.write(.edit))
                        }
                        .font(.title)
                        .foregroundColor(.orange)
                        
                        Spacer()
                        
                        Option(icon: session.secret.favourite ? "heart.fill" : "heart") {
                            
                        }
                        .foregroundStyle(.secondary)
                        
                        Option(icon: "tag.square.fill") {
                            session.modal.send(.tags)
                        }
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(item: $modal, content: modal)
            .onReceive(session.modal) {
                change($0)
            }
            .onAppear {
                session.archive = .init()
            }
        }
    }
    
    private func change(_ new: Modal) {
        guard new != modal else { return }
        if modal == nil {
            modal = new
        } else {
            modal = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                modal = new
            }
        }
    }
    
    @ViewBuilder private func modal(_ modal: Modal) -> some View {
        switch modal {
        case .tags:
            Tags(session: $session)
        case .safe:
            Safe(session: $session)
        case .purchase:
            Purchase(session: $session)
        case let .write(write):
            Writer(session: $session, write: write)
        }
    }
}
