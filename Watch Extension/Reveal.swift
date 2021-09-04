import SwiftUI
import Secrets

struct Reveal: View {
    let secret: Secret
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(verbatim: secret.name)
                    .font(.callout)
                    .padding(.top)
                Text(.init(secret.payload))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical)
                Text(secret.date, style: .relative)
                    .foregroundColor(.secondary)
                    .font(.caption2)
                    .padding(.bottom)
                ForEach(secret.tags.sorted(), id: \.self) { tag in
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.orange)
                        Text(verbatim: "\(tag)")
                            .foregroundColor(.white)
                            .font(.caption2)
                            .padding(6)
                    }
                    .fixedSize()
                }
                Spacer()
                    .frame(height: 20)
            }
        }
    }
}
