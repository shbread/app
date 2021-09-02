import SwiftUI
import Secrets

struct Tags: View {
    @Binding var session: Session
    
    var body: some View {
        Popup(title: "Tags", leading: { }) {
            List(Tag
                    .allCases
                    .sorted(), id: \.self) { tag in
                Button {
                    Task {
                        if session.secret.tags.contains(tag) {
                            await cloud.remove(index: session.selected!, tag: tag)
                        } else {
                            await cloud.add(index: session.selected!, tag: tag)
                        }
                    }
                } label: {
                    HStack {
                        Text(verbatim: "\(tag)")
                            .font(.callout)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: session.secret.tags.contains(tag) ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundColor(session.secret.tags.contains(tag) ? .orange : .secondary)
                    }
                    .padding(.vertical, 10)
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}
