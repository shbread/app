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
        case let .tags(index):
            Tags(session: $session, index: index)
        case let .write(write):
            Writer(session: $session, write: write)
        case .safe:
            Safe(session: $session)
        }
    }
}
