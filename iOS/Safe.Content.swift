import SwiftUI

extension Safe {
    struct Content: View {
        @Binding var session: Session
        let state: Store.State
        
        var body: some View {
            switch state {
            case .loading:
                Image(systemName: "hourglass")
                    .resizable()
                    .font(.largeTitle.weight(.ultraLight))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)
                    .symbolVariant(.circle)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.tertiary, Color.accentColor)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            case let .error(error):
                VStack {
                    Text(verbatim: error)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 300)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                }
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            case let .products(products):
                TabView {
                    ForEach(products, id: \.self) {
                        Item(session: $session, product: $0)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
        }
    }
}
