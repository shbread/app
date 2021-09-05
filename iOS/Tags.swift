import SwiftUI
import Secrets

struct Tags: View {
    @Binding var session: Session
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Dismiss {
                dismiss()
            })
        }
    }
}
