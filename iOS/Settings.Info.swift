import SwiftUI

extension Settings {
    struct Info: View {
        let title: String
        let text: String
        
        var body: some View {
            ScrollView {
                Text(.init(text))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 340, alignment: .leading)
                    .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
