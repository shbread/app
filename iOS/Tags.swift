import SwiftUI

struct Tags: View {
    @Binding var session: Session
    let index: Int
    
    var body: some View {
        Popup(title: "Tags", leading: { }) {
            List {
                ForEach(Tag
                            .allCases
                            .sorted {
                    "\($0)".localizedCompare("\($1)") == .orderedAscending
                }, id: \.self) { tag in
                    Button {
                        
                    } label: {
                        HStack {
                            Text(verbatim: "\(tag)")
                                .font(.callout)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: session[index].tags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundColor(session[index].tags.contains(tag) ? .orange : .secondary)
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}
