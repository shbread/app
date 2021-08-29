import SwiftUI

struct Writer: UIViewRepresentable {
    @Binding var session: Session
    let write: App.Modal.Write
    @Environment(\.presentationMode) var visible
    
    func makeCoordinator() -> Coordinator {
        .init(wrapper: self)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) { }
}
