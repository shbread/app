import SwiftUI

struct Safe: View {
    @Binding var session: Session
    
    var body: some View {
        NavigationView {
            
        }
        .animation(.easeInOut(duration: 1), value: 1)
        .transition(.slide)
    }
}
