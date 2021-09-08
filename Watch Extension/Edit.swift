import SwiftUI
import Secrets

struct Edit: View {
    let index: Int
    let secret: Secret
    
    var body: some View {
        List {
            Section {
                if secret.payload.isEmpty {
                    Text("Empty secret")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                } else {
                    Text(.init(secret.payload))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .privacySensitive()
                }
            }
            .listRowBackground(Color.clear)
            
            Section {
                ForEach(secret.tags.sorted(), id: \.self) { tag in
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.orange)
                        Text(verbatim: "\(tag)")
                            .foregroundColor(.white)
                            .font(.caption2)
                            .padding(6)
                    }
                    .fixedSize()
                    .privacySensitive()
                }
            }
            .listRowBackground(Color.clear)
            
            Section {
                Text(verbatim: secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                    .foregroundColor(.secondary)
                    .font(.caption2)
            }
            .listRowBackground(Color.clear)
            
            Section {
                NavigationLink {
                    Purchases()
                } label: {
                    Label("Edit", systemImage: "pencil.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            }
        }
        .navigationTitle(secret.name)
    }
}
