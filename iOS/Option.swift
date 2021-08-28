import SwiftUI

struct Option: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .frame(width: 50, height: 50)
                .contentShape(Rectangle())
        }
    }
}
