import SwiftUI

struct Purchase: View {
    @Binding var session: Session
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "lock.square")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
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
            Button("In-App Purchases") {
                session.modal.send(.safe)
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
