import SwiftUI
import Secrets

struct Sidebar: View {
    let archive: Archive
    
    var body: some View {
        if archive.secrets.isEmpty {
            Text("No secrets stored yet, continue on your iPhone or iPad.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        } else {
            NavigationView {
                List(0 ..< archive.secrets.count, id: \.self) { index in
                    NavigationLink(destination: Reveal(secret: archive.secrets[index])) {
                        Group {
                            Text(verbatim: archive.secrets[index].name + "\n")
                                .font(.footnote)
                            + Text(archive.secrets[index].date, style: .relative)
                                .foregroundColor(.secondary)
                                .font(.caption2)
                        }
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .privacySensitive()
                    }
                }
            }
        }
    }
}
