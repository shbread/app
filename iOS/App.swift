import SwiftUI
import LocalAuthentication
import Archivable
import Secrets

let cloud = Cloud.new
let store = Store()

@main struct App: SwiftUI.App {
    @State private var archive = Archive.new
    @State private var modal: Modal?
    @State private var authenticated = false
    @State private var search = ""
    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = false
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar(search: $search, archive: archive)
                Empty(archive: archive)
            }
            .searchable(text: $search)
            .navigationViewStyle(.columns)
            .onOpenURL {
                guard $0.scheme == "shortbread", $0.host == "create" else { return }
                if archive.available {
//                        modal.send(.write(.create))
                } else {
//                        modal.send(.full)
                }
            }
            .sheet(item: $modal, content: modal)
            .onReceive(cloud.archive) {
                archive = $0
            }
            .onReceive(delegate.store) {
//                change(.safe)
            }
//            .onReceive(session.modal) {
//                change($0)
//            }
            .onAppear {
                if !Defaults.onboarded {
//                    change(.onboard)
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
                    authenticated = false
                }
            default:
                break
            }
        }
    }
    
//    private func change(_ new: Modal) {
//        guard new != modal else { return }
//        if modal == nil {
//            modal = new
//        } else {
//            modal = nil
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//                modal = new
//            }
//        }
//    }
    
    @ViewBuilder private func modal(_ modal: Modal) -> some View {
        switch modal {
        case .safe:
            Safe(archive: archive)
        case .full:
            Full()
        case .onboard:
            Onboard()
        case .settings:
            Settings()
        case let .tags(index, secret):
            Tags(index: index, secret: secret)
        case let .write(write):
            Writer(write: write)
                .privacySensitive()
        }
    }
    
    private func auth() {
        let context = LAContext()
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
            authenticated = true
            return
        }

        context
            .evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate to access your secrets") {
                guard $0, $1 == nil else { return }
                DispatchQueue
                    .main
                    .async {
                        authenticated = true
                    }
            }
    }
}
