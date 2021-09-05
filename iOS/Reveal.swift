import SwiftUI

struct Reveal: View {
    @Binding var session: Session
    
    var body: some View {
        if session.selected == nil {
            Empty(session: $session)
        } else {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Text(.init(session.secret.payload))
                            .kerning(1)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                            .padding(.top)
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                            .textSelection(.enabled)
                        
                        Text(session.secret.date, style: .relative)
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal)
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                        
                        Tagger(secret: session.secret, max: .init(geometry.size.width / 75))
                            .padding()
                    }
                    .privacySensitive()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Toolbar(session: $session)
                }
            }
            .navigationTitle(session.secret.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
