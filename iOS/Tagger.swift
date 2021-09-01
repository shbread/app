import SwiftUI
import Secrets

struct Tagger: View {
    let tag: Tag
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.orange)
            Text(verbatim: "\(tag)")
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
        }
        .fixedSize()
    }
}
