import SwiftUI
import Secrets

struct Reveal: View {
    let index: Int
    let secret: Secret
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text(.init(secret.payload))
                        .kerning(1)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.top)
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                        .textSelection(.enabled)
                    
                    Text(secret.date, style: .relative)
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal)
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                    
                    Tagger(secret: secret, max: .init(geometry.size.width / 75))
                        .padding()
                }
                .privacySensitive()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Toolbar(index: index, secret: secret)
            }
        }
        .navigationTitle(secret.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
