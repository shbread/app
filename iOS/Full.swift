import SwiftUI

struct Full: View {
    @Binding var session: Session
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "lock.square")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.quaternary)
            Text("You reached the limit of\nsecrets that you can keep.")
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            Text("Purchase more capacity\nto create a new secret.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            Button {
                session.modal.send(.safe)
            } label: {
                Text("In-App Purchases")
                    .frame(maxWidth: 200)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            Button("Cancel") {
                dismiss()
            }
            .font(.callout)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(.ultraThinMaterial)
    }
}
