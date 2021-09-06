import SwiftUI

struct Writer: UIViewRepresentable {
    let write: App.Modal.Write
    
    func makeCoordinator() -> Coordinator {
        .init(write: write)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) { }
}
