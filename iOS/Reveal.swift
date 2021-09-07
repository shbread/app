import SwiftUI
import Secrets

struct Reveal: View {
    let index: Int
    let secret: Secret
    @State private var edit = false
    
    var body: some View {
        if edit {
            Writer(write: .edit(index, secret))
        } else {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Text(.init(secret.payload))
                            .kerning(1)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                            .textSelection(.enabled)
                        
                        Text(secret.date, style: .relative)
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                        
                        Tagger(secret: secret, tags: .init(geometry.size.width / 75))
                    }
                    .privacySensitive()
                    .padding(UIDevice.current.userInterfaceIdiom == .pad ? 80 : 30)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Copy") {
                        UIPasteboard.general.string = secret.payload
                        Task {
                            await Notifications.send(message: "Secret copied!")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .font(.callout)
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            edit = true
                        }
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                    }
                    
                    Spacer()
                    
                    Button("Copy") {
                        UIPasteboard.general.string = secret.payload
                        Task {
                            await Notifications.send(message: "Secret copied!")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .font(.footnote)
                }
            }
            .navigationTitle(secret.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
