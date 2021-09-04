import SwiftUI

struct Settings: View {
    @Binding var session: Session
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "lock.square")
                            .resizable()
                            .font(.largeTitle.weight(.ultraLight))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.tertiary)
                        Group {
                            Text(verbatim: "Shortbread\n")
                            + Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")
                        }
                        .multilineTextAlignment(.center)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 20)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.grouped)
            .navigationBarTitle("Settings", displayMode: .large)
            .navigationBarItems(trailing:
                                    Button {
                                        dismiss()
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.footnote)
                                            .frame(height: 50)
                                            .padding(.leading, 40)
                                            .contentShape(Rectangle())
                                    }
                                    .foregroundStyle(.secondary))
        }
    }
}
