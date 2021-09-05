import SwiftUI

extension Settings {
    struct Info: View {
        let title: String
        let text: String
        
        var body: some View {
            ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                    Text(.init(text))
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 440, alignment: .leading)
                        .padding()
                }
                .padding()
                .padding(.bottom, 40)
            }
            .background(.ultraThickMaterial)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
