import SwiftUI
import Secrets

struct Spine: View {
    let archive: Archive
    @State private var index: Int? = 0
    
    var body: some View {
        List {
            NavigationLink(tag: 0, selection: $index) {
                Sidebar(archive: archive)
            } label: {
                Label("Secrets", image: "lock")
            }
            NavigationLink(tag: 1, selection: $index) {
                Circle()
            } label: {
                Label("Something", image: "lock")
            }
        }
    }
}
