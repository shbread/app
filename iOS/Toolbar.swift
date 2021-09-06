import SwiftUI
import Secrets

struct Toolbar: View {
    let index: Int
    let secret: Secret
    @State private var delete = false
    
    var body: some View {
        Menu {
            Button {
//                session.modal.send(.tags)
            } label: {
                Text("Tags")
                Image(systemName: "tag")
            }
            
            Button {
//                session.modal.send(.write(.edit))
            } label: {
                Text("Edit")
                Image(systemName: "pencil.circle")
            }
            
            NavigationLink(destination: Writer(write: .edit(index, secret))) {
                Text("Edit")
                Image(systemName: "pencil.circle")
            }
            
            Button {
//                session.modal.send(.write(.rename))
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
//                let index = session.selected!
//                session.selected = nil
                
                Task {
                    await cloud.delete(index: index)
                    await Notifications.send(message: "Deleted secret!")
                }
            }
        }
        
        Spacer()
        
        NavigationLink(destination: Writer(write: .edit(index, secret))) {
            Image(systemName: "pencil")
                .symbolRenderingMode(.hierarchical)
                .frame(width: 50, height: 36)
                .contentShape(Rectangle())
        }
//        Option(icon: secret.favourite ? "heart.fill" : "heart") {
//            Task {
//                await cloud
//                    .update(index: index, favourite: secret.favourite)
//            }
//        }
//        .foregroundColor(secret.favourite ? .accentColor : .secondary)
        
        Spacer()
        
        Button("Copy") {
            UIPasteboard.general.string = secret.payload
            Task {
                await Notifications.send(message: "Secret copied!")
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
        .font(.callout)
    }
}
