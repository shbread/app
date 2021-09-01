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
                        Menu {
                            Button {
                                session.modal.send(.tags)
                            } label: {
                                Text("Tags")
                                Image(systemName: "tag")
                            }
                            
                            Button {
                                session.modal.send(.write(.edit))
                            } label: {
                                Text("Edit")
                                Image(systemName: "pencil.circle")
                            }
                            
                            Button {
                                
                            } label: {
                                Text("Rename")
                                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            }
                            
                            Button(role: ButtonRole.destructive) {
                                
                            } label: {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .frame(width: 50, height: 40)
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.orange)
                                .padding(4)
                            Option(icon: "doc.on.doc.fill") {
                                session.modal.send(.write(.edit))
                            }
                            .font(.caption2)
                            .foregroundColor(.white)
                        }
                    }
                }
            }
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
        case .purchase:
            Purchase(session: $session)
        case let .write(write):
            Writer(session: $session, write: write)
        }
    }
}
