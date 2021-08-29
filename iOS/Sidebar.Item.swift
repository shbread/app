import SwiftUI

extension Sidebar {
    struct Item: View {
        let secret: Secret
        
        var body: some View {
            HStack(spacing: 0) {
                if secret.favourite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.quaternary)
                        .frame(width: 30)
                        .padding(.trailing, 10)
                } else {
                    Spacer()
                        .frame(width: 40)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text(verbatim: secret.name)
                        .font(.callout)
                        .padding(.vertical, 4)
                    HStack {
                        ForEach(0 ..< secret.tags.count, id: \.self) {
                            Tagger(tag: secret.tags[$0])
                        }
                    }
                }
                Spacer()
            }
        }
    }
}
