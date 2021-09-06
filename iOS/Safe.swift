import SwiftUI
import Secrets

struct Safe: View {
    let archive: Archive
    @Environment(\.dismiss) private var dismiss
    @State private var state = Store.State.loading
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "lock.square")
                    .resizable()
                    .font(.largeTitle.weight(.ultraLight))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.orange)
                    .padding(.leading)
                Text(Int(Float(archive.secrets.count) / .init(archive.capacity) * 100), format: .percent)
                    .font(.callout.weight(.light).monospacedDigit())
                    .foregroundStyle(.secondary)
                Spacer()
                Text(verbatim: "\(archive.secrets.count) / \(archive.capacity) " + (archive.capacity == 1 ? "secret" : "secrets"))
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
            Content(state: state)
            Text("Your secrets capacity is permanent and won't expire, you can create and delete secrets as many times as you want.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: 360)
        }
        .background(.ultraThinMaterial)
        .onReceive(store.state) {
            state = $0
        }
        .task {
            await store.load()
        }
    }
}
