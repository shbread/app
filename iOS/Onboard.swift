import SwiftUI
import Secrets

struct Onboard: View {
    @Binding var session: Session
    @State private var index = 0
    @State private var requested = false
    @Environment(\.dismiss) private var dismiss
    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = true
    
    var body: some View {
        VStack {
            HStack {
                Text("Setting up")
                    .font(.callout)
                    .foregroundStyle(.primary)
                Spacer()
                Button("Skip") {
                    dismiss()
                }
                .foregroundStyle(.secondary)
                .buttonStyle(.borderless)
                .font(.callout)
            }
            .padding()
            TabView(selection: $index) {
                card0
                card1
                card2
                card3
            }
            .tabViewStyle(.page)
        }
        .background(Color(.secondarySystemBackground))
    }
    
    private var card0: some View {
        VStack {
            Image(systemName: "lock.square")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.orange)
            Text("Just a few steps to\nstart protecting your secrets")
                .font(.callout)
                .foregroundStyle(.primary)
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
    }
    
    private var card1: some View {
        VStack {
            Image(systemName: "faceid")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .symbolRenderingMode(.multicolor)
            Toggle("Secure with Face ID", isOn: $authenticate)
                .toggleStyle(SwitchToggleStyle(tint: .orange))
                .font(.callout)
                .frame(maxWidth: 200)
                .padding()
            HStack {
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 0
                    }
                } label: {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.bordered)
                .font(.callout)
                .padding(.trailing)
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 2
                    }
                } label: {
                    Image(systemName: "arrow.right")
                }
                .buttonStyle(.bordered)
                .font(.callout)
                .padding(.leading)
            }
        }
        .tag(1)
    }
    
    private var card2: some View {
        VStack {
            Image(systemName: "envelope.badge")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .symbolRenderingMode(.multicolor)
            Text(Copy.notifications)
                .font(.footnote)
                .frame(maxWidth: 310)
                .padding([.leading, .trailing, .top])
            if requested {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.multicolor)
                    .padding()
            } else {
                Button("Allow notifications") {
                    Task {
                        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
                        requested = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .font(.callout)
                .padding()
            }
            HStack {
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 1
                    }
                } label: {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.bordered)
                .font(.callout)
                .padding(.trailing)
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 3
                    }
                } label: {
                    Image(systemName: "arrow.right")
                }
                .buttonStyle(.bordered)
                .font(.callout)
                .padding(.leading)
            }
        }
        .tag(2)
    }
    
    private var card3: some View {
        VStack {
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .symbolRenderingMode(.multicolor)
            Text("All ready!")
                .font(.callout)
                .foregroundStyle(.primary)
                .padding([.top, .leading, .trailing])
            Text("By using this app you accept\nour terms and conditions.\nYou can read them on Settings")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding([.bottom, .leading, .trailing])
            
            Button("Done") {
                Defaults.onboarded = true
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .font(.callout)
            .padding()
            
            HStack {
                Button {
                    withAnimation(.spring(blendDuration: 0.3)) {
                        index = 2
                    }
                } label: {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.bordered)
                .font(.callout)
                .padding(.trailing)
                
                Button {
                    Defaults.onboarded = true
                    session.modal.send(.settings)
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                .buttonStyle(.bordered)
                .font(.callout)
                .padding(.trailing)
            }
        }
        .tag(3)
    }
}
