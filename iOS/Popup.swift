import SwiftUI

struct Popup<Leading, Content>: View where Leading : View, Content : View {
    let title: String
    let leading: Leading
    let content: Content
    @Environment(\.dismiss) private var dismiss
    
    @inlinable public init(title: String, @ViewBuilder leading: () -> Leading, @ViewBuilder content: () -> Content) {
        self.title = title
        self.leading = leading()
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle(title, displayMode: .large)
                .navigationBarItems(leading: leading,
                                    trailing:
                                        Button {
                                            dismiss()
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.callout)
                                                .foregroundStyle(.secondary)
                                                .foregroundColor(.secondary)
                                                .frame(height: 50)
                                                .padding(.leading, 40)
                                                .contentShape(Rectangle())
                                        })
        }
        .navigationViewStyle(.stack)
    }
}
