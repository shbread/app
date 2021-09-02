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
                                session.modal.send(.write(.rename))
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
                                .symbolRenderingMode(.hierarchical)
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .frame(width: 50, height: 40)
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        
                        Option(icon: session.secret.favourite ? "heart.fill" : "heart") {
                            Task {
                                await cloud
                                    .update(index: session.selected!, favourite: !session.secret.favourite)
                            }
                        }
                        .foregroundColor(session.secret.favourite ? .accentColor : .secondary)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.orange)
                                Text("Copy")
                                    .font(.callout.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                            }
                        }
                        
                        .foregroundColor(.orange)
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
