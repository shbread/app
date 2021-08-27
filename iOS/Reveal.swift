import SwiftUI

struct Reveal: View {
    @Binding var session: Session
    let index: Int
    
    var body: some View {
        ScrollView {
            Text(verbatim: session.archive.secrets[index].value)
                .kerning(1)
                .padding(.horizontal)
                .padding(.top)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            
            Text(verbatim: RelativeDateTimeFormatter().string(from: session.archive.secrets[index].date))
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            
            HStack {
                ForEach(0 ..< session.archive.secrets[index].tags.count, id: \.self) {
                    Tagger(tag: session.archive.secrets[index].tags[$0])
                }
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.pink)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "tag.fill")
                }
            }
        }
        .navigationBarTitle(session.archive.secrets[index].name, displayMode: .large)
    }
}
