import SwiftUI
import StoreKit
import Secrets

extension Safe.Content {
    struct Item: View {
        @Binding var session: Session
        let product: Product
        
        var body: some View {
            VStack {
                HStack {
                    Image(product.id)
                    Group {
                        Text(verbatim: product.displayName)
                            .foregroundColor(.primary)
                            .font(.title)
                        + Text(verbatim: "\n" + product.description)
                            .foregroundColor(.secondary)
                            .font(.callout)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding(.horizontal)
                .frame(maxWidth: 300)
                HStack {
                    Spacer()
                    Text(verbatim: product.displayPrice)
                        .font(.title3.monospacedDigit())
                        .foregroundStyle(.primary)
                    if product.id != Purchase.one.rawValue {
                        Group {
                            Text("Save ")
                            + Text(Purchase(rawValue: product.id)!.save, format: .percent)
                        }
                        .foregroundColor(.orange)
                        .font(.footnote.bold())
                    }
                    Spacer()
                }
                .padding(.top)
                Button("Purchase") {
                    Task {
                        await store.purchase(product)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}