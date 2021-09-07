import SwiftUI
import LocalAuthentication
import Archivable
import Secrets

let cloud = Cloud.new
let store = Store()

@main struct App: SwiftUI.App {
    @State private var archive = Archive.new
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
            .onReceive(cloud.archive) {
                archive = $0
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
