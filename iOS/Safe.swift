import SwiftUI

struct Safe: View {
    @Binding var session: Session
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "lock.square")
                    .resizable()
                    .font(.largeTitle.weight(.ultraLight))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .foregroundColor(.orange)
                    .padding(.leading)
                Text(session.archive.secrets.count / session.archive.capacity * 100, format: .percent)
                    .font(.callout.weight(.light).monospacedDigit())
                    .foregroundStyle(.secondary)
                Spacer()
                Text(verbatim: "\(session.archive.secrets.count) / \(session.archive.capacity) " + (session.archive.capacity == 1 ? "secret" : "secrets"))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 60, height: 60)
                        .contentShape(Rectangle())
                }
                .foregroundStyle(.secondary)
            }
            TabView {
                VStack {
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
                }
                Circle()
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .background(.ultraThinMaterial)
    }
}
