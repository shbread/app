import SwiftUI

struct Onboard: View {
    @Environment(\.dismiss) private var dismiss
    @State private var index = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Setting up")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Skip") {
                    dismiss()
                }
                .foregroundStyle(.tertiary)
                .buttonStyle(.borderless)
                .font(.callout)
            }
            .padding()
            TabView(selection: $index) {
                VStack {
                    Image(systemName: "lock.square")
                        .resizable()
                        .font(.largeTitle.weight(.ultraLight))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                        .foregroundColor(.orange)
                    Text("Just a few steps\nbefore starting protecting your secrets")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding()
                    Button {
                        withAnimation(.spring(blendDuration: 0.3)) {
                            index = 1
                        }
                    } label: {
                        Image(systemName: "arrow.right")
                    }
                    .buttonStyle(.bordered)
                    .font(.callout)
                }
                .tag(0)
                
                VStack {
                    Image(systemName: "lock.square")
                        .resizable()
                        .font(.largeTitle.weight(.ultraLight))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                        .foregroundColor(.orange)
                    Text("Just a few steps\nbefore starting protecting your secrets")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding()
                    Button {
                        withAnimation(.spring(blendDuration: 0.3)) {
                            index = 1
                        }
                    } label: {
                        Image(systemName: "arrow.right")
                    }
                    .buttonStyle(.bordered)
                    .font(.callout)
                }
                .tag(1)
                
                Card {
                    
                }
                .tag(2)
            }
            .tabViewStyle(.page)
        }
        .background(Color(.secondarySystemBackground))
    }
}
