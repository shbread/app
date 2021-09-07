import SwiftUI
import Secrets

extension Sidebar {
    struct Item: View {
        let index: Int
        let secret: Secret
        let tags: Int
        @State private var name = ""
        @State private var disabled = true
        @FocusState private var focus: Bool
        
        var body: some View {
            NavigationLink(destination: Reveal(index: index, secret: secret, edit: false)) {
                HStack(spacing: 0) {
                    if secret.favourite {
                        Image(systemName: "heart.fill")
                            .font(.caption2)
                            .foregroundColor(.accentColor)
                            .frame(width: 20)
                            .padding(.trailing, 5)
                    } else {
                        Spacer()
                            .frame(width: 25)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        TextField(secret.name, text: $name)
                            .focused($focus)
                            .submitLabel(.done)
                            .onSubmit {
                                Task {
                                    await cloud.update(index: index, name: name)
                                }
                            }
                            .disabled(disabled)
                            .privacySensitive()
                        Text(verbatim: secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                        Tagger(secret: secret, tags: tags)
                            .privacySensitive()
                    }
                    Spacer()
                }
                .onAppear {
                    name = secret.name
                }
            }
            .onChange(of: focus) {
                if $0 == false {
                    disabled = true
                    name = secret.name
                }
            }
            .swipeActions(edge: .leading) {
                Button {
                    Task {
                        await cloud.update(index: index, favourite: !secret.favourite)
                    }
                } label: {
                    Label("Favourite", systemImage: secret.favourite ? "heart.slash" : "heart")
                }
                .tint(secret.favourite ? .gray : .pink)
            }
            .swipeActions {
                Button {
                    
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.pink)
                Button {
                    disabled = false
                    DispatchQueue
                        .main
                        .asyncAfter(deadline: .now() + 1.2) {
                            focus = true
                        }
                } label: {
                    Label("Rename", systemImage: "pencil")
                }
                .tint(.orange)
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button(role: .cancel) {
                        focus = false
                    } label: {
                        Text("Cancel")
                            .font(.footnote)
                    }
                    .tint(.pink)
                }
            }
        }
    }
}
