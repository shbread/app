import SwiftUI
import Secrets

struct Reveal: View {
    let secret: Secret
    
    var body: some View {
        Text(.init(secret.payload))
    }
}
