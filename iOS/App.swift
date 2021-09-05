import SwiftUI
import LocalAuthentication
import Archivable
import Secrets

let cloud = Cloud.new
let store = Store()

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @State private var modal: Modal?
    @State private var authenticated = false
    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = false
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authenticated || !authenticate {
                    Sidebar(session: $session)
                    Reveal(session: $session)
                } else {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .font(.largeTitle.weight(.ultraLight))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.quaternary)
                }
            }
            .navigationViewStyle(.columns)
            .onOpenURL {
                guard $0.scheme == "shortbread" else { return }
                session.selected = nil
                session.create()
            }
            .sheet(item: $modal, content: modal)
            .onReceive(cloud.archive) {
                session.archive = $0
            }
            .onReceive(delegate.store) {
                change(.safe)
            }
            .onReceive(session.modal) {
                change($0)
            }
            .onAppear {
                if !Defaults.onboarded {
                    change(.onboard)
                }
            }
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                if authenticate && !authenticated {
                    auth()
                } else {
                    authenticated = true
                }
                cloud.pull.send()
            case .background:
                if authenticate {
                    modal = nil
                    session.selected = nil
                    authenticated = false
                }
            default:
                break
            }
        }
    }
    
    private func change(_ new: Modal) {
        guard new != modal else { return }
        if modal == nil {
            modal = new
        } else {
            modal = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
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
        case .onboard:
            Onboard(session: $session)
        case .settings:
            Settings(session: $session)
        case let .write(write):
            Writer(session: $session, write: write)
        }
    }
    
    private func auth() {
        let context = LAContext()
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
            authenticated = true
            return
        }

        context
            .evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate to access your secrets.") {
                guard $0, $1 == nil else { return }
                DispatchQueue
                    .main
                    .async {
                        authenticated = true
                    }
            }
    }
}
