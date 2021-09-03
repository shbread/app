import SwiftUI

struct Toolbar: View {
    @Binding var session: Session
    @State private var delete = false
    
    var body: some View {
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
            
            Button(role: .destructive) {
                delete = true
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
        .confirmationDialog("Delete secret?", isPresented: $delete) {
            Button("Delete", role: .destructive) {
                let index = session.selected!
                session.selected = nil
//                                Notifications.send(message: "Deleted card")
                Task {
                    await cloud.delete(index: index)
                }
            }
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
        
        Button("Copy") {
            UIPasteboard.general.string = session.secret.payload
            //Notification.pasteboard
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
        .font(.callout)
    }
}
