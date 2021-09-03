import SwiftUI

extension Onboard {
    struct Card<Content>: View where Content : View {
        let content: Content
        
        @inlinable public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemBackground))
                content
            }
            .frame(maxWidth: 340, maxHeight: 280)
            .padding()
        }
    }
}
