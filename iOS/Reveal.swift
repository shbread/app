import SwiftUI

struct Reveal: View {
    @Binding var session: Session
    let index: Int
    
    var body: some View {
        ScrollView {
            Text(verbatim: session[index].value)
                .kerning(1)
                .padding(.horizontal)
                .padding(.top)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            
            Text(verbatim: RelativeDateTimeFormatter().string(from: session[index].date))
                .font(.footnote)
                .foregroundColor(.secondary)
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
                .foregroundColor(.primary)
                
                Option(icon: "doc.on.doc.fill") {
                    
                }
                .font(.footnote)
                .foregroundColor(.primary)
                
                Spacer()
                
                Option(icon: "pencil.circle.fill") {
                    
                }
                .font(.title)
                .foregroundColor(.orange)
                
                Spacer()
                
                Option(icon: session[index].favourite ? "heart.fill" : "heart") {
                    
                }
                .foregroundColor(.primary)
                
                Option(icon: "tag.square.fill") {
                    
                }
                .font(.title3)
                .foregroundColor(.primary)
            }
        }
        .navigationBarTitle(session[index].name, displayMode: .inline)
    }
}
