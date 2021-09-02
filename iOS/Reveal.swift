import SwiftUI

struct Reveal: View {
    @Binding var session: Session
    
    var body: some View {
        ScrollView {
            Text(verbatim: session.secret.payload)
                .kerning(1)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.top)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            
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
        .navigationBarTitle(session.secret.name, displayMode: .inline)
    }
}
