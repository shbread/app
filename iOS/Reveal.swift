import SwiftUI

struct Reveal: View {
    @Binding var session: Session
    
    var body: some View {
        if session.selected == nil {
            Empty(session: $session)
        } else {
            ScrollView {
                Text(.init(session.secret.payload))
                    .kerning(1)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.top)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                    .textSelection(.enabled)
                
                Text(verbatim: RelativeDateTimeFormatter().string(from: session.secret.date))
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                
                GeometryReader { geometry in
                    Tagger(secret: session.secret, max: .init(geometry.size.width / 75))
                        .padding()
                }
            }
            .privacySensitive()
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Toolbar(session: $session)
                }
            }
            .navigationBarTitle(session.secret.name, displayMode: .inline)
        }
    }
}
