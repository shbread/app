import SwiftUI
import Secrets

struct Reveal: View {
    let index: Int
    let secret: Secret
    @State private var first = true
    @State private var editing = false
    
    var body: some View {
        if editing {
            Writer(index: index, secret: secret, editing: $editing)
        } else {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Text(.init(secret.payload))
                            .kerning(1)
                            .font(.title3.weight(.regular))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                            .textSelection(.enabled)
                            .privacySensitive()
                        
                        Text(verbatim: secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                        
                        Tagger(secret: secret, tags: .init(geometry.size.width / 75))
                            .privacySensitive()
                    }
                    .padding(UIDevice.pad ? 80 : 30)
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
                    
                    Button(action: edit) {
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
            .onAppear {
                if secret.payload.isEmpty && secret.name == "Untitled" && secret.tags.isEmpty && secret.date.timeIntervalSince(.now) > -2 {
                    edit()
                }
            }
            .navigationTitle(secret.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func edit() {
        withAnimation(.easeInOut(duration: 0.5)) {
            editing = true
        }
    }
}
