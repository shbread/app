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
            
            HStack {
                ForEach(session.secret.tags.sorted(), id: \.self, content: Tagger.init(tag:))
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle(session.secret.name, displayMode: .inline)
    }
}
