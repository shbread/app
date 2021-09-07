import SwiftUI
import Secrets

struct Sidebar: View {
    let archive: Archive
    
    var body: some View {
        NavigationView {
            List {
                if archive.count == 0 {
                    Text("Create your first secret")
                        .foregroundStyle(.secondary)
                        .padding()
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(0 ..< archive.count, id: \.self) { index in
                        NavigationLink(destination: Reveal(secret: archive[index])) {
                            Group {
                                Text(verbatim: archive[index].name + "\n")
                                    .font(.footnote)
                                + Text(archive[index].date, style: .relative)
                                    .foregroundColor(.secondary)
                                    .font(.caption2)
                            }
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        }
                        .privacySensitive()
                    }
                }
                
//                NavigationLink(destination: Create(archive: archive)) {
//                    Image(systemName: "plus.circle.fill")
//                        .font(.largeTitle)
//                        .symbolRenderingMode(.hierarchical)
//                        .foregroundColor(.orange)
//                        .frame(maxWidth: .greatestFiniteMagnitude)
//                }
//                .buttonStyle(.borderedProminent)
//                .listRowBackground(Color.clear)
            }
        }
    }
}
