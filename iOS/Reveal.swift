import SwiftUI

struct Reveal: View {
    @Binding var session: Session
    let index: Int
    
    var body: some View {
        ScrollView {
            Text(verbatim: session[index].value)
                .kerning(1)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.top)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            
            Text(verbatim: RelativeDateTimeFormatter().string(from: session[index].date))
                .font(.footnote)
                .foregroundStyle(.tertiary)
                .padding(.horizontal)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            
            HStack {
                ForEach(0 ..< session[index].tags.count, id: \.self) {
                    Tagger(tag: session[index].tags[$0])
                }
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Option(icon: "trash.fill") {
                    
                }
                .font(.callout)
                .foregroundStyle(.secondary)
                
                Option(icon: "doc.on.doc.fill") {
                    
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                
                Spacer()
                
                Option(icon: "pencil.circle.fill") {
                    
                }
                .font(.title)
                .foregroundColor(.orange)
                
                Spacer()
                
                Option(icon: session[index].favourite ? "heart.fill" : "heart") {
                    
                }
                .foregroundStyle(.secondary)
                
                Option(icon: "tag.square.fill") {
                    
                }
                .font(.title3)
                .foregroundStyle(.secondary)
            }
        }
        .navigationBarTitle(session[index].name, displayMode: .inline)
    }
}
