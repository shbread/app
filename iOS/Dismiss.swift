import SwiftUI

struct Dismiss: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.footnote)
                .frame(height: 50)
                .padding(.leading, 40)
                .contentShape(Rectangle())
        }
        .foregroundStyle(.secondary)
    }
}
