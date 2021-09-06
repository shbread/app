import SwiftUI
import Secrets

struct Tags: View {
    let index: Int
    let secret: Secret
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(Tag
                    .allCases
                    .sorted(), id: \.self) { tag in
                Button {
                    Task {
                        if secret.tags.contains(tag) {
                            await cloud.remove(index: index, tag: tag)
                        } else {
                            await cloud.add(index: index, tag: tag)
                        }
                    }
                } label: {
                    HStack {
                        Text(verbatim: "\(tag)")
                            .font(.callout)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: secret.tags.contains(tag) ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundColor(secret.tags.contains(tag) ? .orange : .secondary)
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
