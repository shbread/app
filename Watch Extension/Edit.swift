import SwiftUI
import Secrets

struct Edit: View {
    let index: Int
    @State var name: String
    @State var payload: String
    
    var body: some View {
        List {
            TextField("Name", text: $name)
                .onSubmit {
                    Task {
                        await cloud.update(index: index, name: name)
                    }
                }
                .privacySensitive()
            TextField("Secret", text: $payload)
                .onSubmit {
                    Task {
                        await cloud.update(index: index, payload: payload)
                    }
                }
                .privacySensitive()
        }
        .navigationTitle("Edit")
    }
}
