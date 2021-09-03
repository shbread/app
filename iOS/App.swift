import SwiftUI
import Archivable

let cloud = Cloud.new

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @State private var modal: Modal?
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar(session: $session)
                Reveal(session: $session)
            }
            .navigationViewStyle(.columns)
            .sheet(item: $modal, content: modal)
            .onReceive(cloud.archive) {
                session.archive = $0
            }
            .onReceive(session.modal) {
                change($0)
            }
        }
        .onChange(of: phase) {
            if $0 == .active {
                cloud.pull.send()
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
        case .full:
            Full(session: $session)
        case let .write(write):
            Writer(session: $session, write: write)
        }
    }
}
