import SwiftUI
import Secrets

struct Sidebar: View {
    let archive: Archive
    @State private var search =  ""
    @State private var selected: Int?
    @State private var filtered = [Int]()
    
    var body: some View {
        NavigationView {
            List {
                if search.isEmpty {
                    Section {
                        if archive.count == 0 {
                            Text("Create your first secret")
                                .font(.footnote)
                                .listRowBackground(Color.clear)
                        } else {
                            Text(verbatim: "\(archive.count) / \(archive.capacity) " + (archive.capacity == 1 ? "secret" : "secrets"))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .listRowBackground(Color.clear)
                        }
                    }
                }
                
                Section {
                    ForEach(filtered, id: \.self) { index in
                        NavigationLink(tag: index, selection: $selected) {
                            Reveal(secret: archive[index])
                        } label: {
                            Text(verbatim: archive[index].name)
                                .font(.callout)
                                .fixedSize(horizontal: false, vertical: true)
                                .privacySensitive()
                        }
                    }
                }
                
                if search.isEmpty {
                    Section {
                        if archive.available {
                            Button {
                                Task {
                                    selected = await cloud.secret()
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.largeTitle)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.orange)
                                    .frame(maxWidth: .greatestFiniteMagnitude)
                            }
                            .listRowBackground(Color.clear)
                        } else {
                            Text("You reached the limit of secrets that you can keep.")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .listRowBackground(Color.clear)
                            NavigationLink(tag: -1, selection: $selected) {
                                Purchases()
                            } label: {
                                Label("In-App Purchases", systemImage: "cart")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
            .searchable(text: $search)
            .onAppear {
                filtered = archive.filter(favourites: false, search: search)
            }
            .onChange(of: archive) {
                filtered = $0.filter(favourites: false, search: search)
            }
            .onChange(of: search) {
                filtered = archive.filter(favourites: false, search: $0)
            }
        }
    }
}
