import SwiftUI
import Secrets

struct Sidebar: View {
    let archive: Archive
    
    var body: some View {
        if archive.secrets.isEmpty {
            Text("No projects started, continue on your iPhone, iPad or Mac")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        } else {
            NavigationView {
                List(0 ..< archive.secrets.count, id: \.self) { index in
                    NavigationLink(destination: Reveal(secret: archive.secrets[index])) {
                        Group {
                            Text(verbatim: archive.secrets[index].name)
                                .font(.footnote.bold())
                            + Text(archive.secrets[index].date, style: .relative)
                                .foregroundColor(.secondary)
                                .font(.caption2)
                        }
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    }
                }
            }
        }
    }
}
