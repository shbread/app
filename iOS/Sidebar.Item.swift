import SwiftUI

extension Sidebar {
    struct Item: View {
        let secret: Secret
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(verbatim: secret.name)
                        .padding(.vertical, 4)
                    HStack {
                        ForEach(0 ..< secret.tags.count, id: \.self) {
                            Tagger(tag: secret.tags[$0])
                        }
                    }
                }
                Spacer()
                if secret.favourite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }
}
