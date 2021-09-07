import SwiftUI
import Secrets

struct Capacity: View {
    let archive: Archive
    @State private var state = Store.State.loading
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Image(systemName: "lock.square")
                    .resizable()
                    .font(.largeTitle)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.orange)
                    .padding(.leading)
                Text(Int(Float(archive.secrets.count) / .init(archive.capacity) * 100), format: .percent)
                    .foregroundColor(.secondary)
                    .font(.callout.monospacedDigit())
                + Text(" used")
                    .foregroundColor(.secondary)
                    .font(.callout.monospacedDigit())
                Spacer()
                Text(verbatim: "\(archive.secrets.count) / \(archive.capacity) " + (archive.capacity == 1 ? "secret" : "secrets"))
                    .font(.callout.monospacedDigit())
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.top)
            Content(state: state)
            Text("Your secrets capacity is permanent and won't expire, you can create and delete secrets as many times as you want.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: 360)
        }
        .navigationTitle("Capacity")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(store.state) {
            state = $0
        }
        .task {
            await store.load()
        }
    }
}
