import SwiftUI

struct Empty: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Image(systemName: "lock.square")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundStyle(.quaternary)
            Text(session.archive.secrets.isEmpty ? "Create your first secret" : "Select a secret from the list\nor create a new one")
                .font(.callout)
                .foregroundStyle(.tertiary)
                .padding(.top)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
    }
}
