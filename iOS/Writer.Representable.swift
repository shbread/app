import SwiftUI

extension Writer {
    struct Representable: UIViewRepresentable {
        let write: Write
        
        func makeCoordinator() -> Coordinator {
            .init(write: write)
        }
        
        func makeUIView(context: Context) -> Coordinator {
            context.coordinator
        }
        
        func updateUIView(_: Coordinator, context: Context) { }
    }
}
