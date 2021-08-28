import SwiftUI

struct Tags: View {
    @Binding var session: Session
    let index: Int
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Tag.allCases, id: \.self) {
                    Text(verbatim: "\($0)")
                }
            }
        }
    }
}
