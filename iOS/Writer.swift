import SwiftUI

struct Writer: View {
    let write: Write
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Representable(write: write)
            .privacySensitive()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(write != .create)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if write != .create {
                        Button("Cancel", role: .cancel) {
                            UIApplication.shared.hide()
                            dismiss()
                        }
                        .font(.footnote)
                        .buttonStyle(.borderless)
                        .tint(.pink)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        
                    }
                    .font(.footnote)
                    .buttonStyle(.borderedProminent)
                }
            }
    }
    
    private var title: String {
        switch write {
        case .create:
            return "New secret"
        case let .edit(_, secret):
            return secret.name
        }
    }
}
