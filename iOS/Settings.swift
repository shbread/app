import SwiftUI
import Secrets

struct Settings: View {
    @State private var requested = true
    @State private var enabled = true
    @Environment(\.dismiss) private var dismiss
    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = false
    
    var body: some View {
        List {
            header
            
            if !requested || !enabled {
                notifications
            }
            
            face
        }
        .listStyle(.grouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await check()
        }
    }
    
    private func check() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        if settings.authorizationStatus == .notDetermined {
            requested = false
        } else if settings.alertSetting == .disabled {
            enabled = false
        }
    }
    
    private var header: some View {
        Section {
            HStack {
                Spacer()
                VStack {
                    Image(systemName: "lock.square")
                        .resizable()
                        .font(.largeTitle.weight(.ultraLight))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                    Group {
                        Text(verbatim: "Shortbread\n")
                        + Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")
                    }
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 60)
                Spacer()
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var notifications: some View {
        Section("Notifications") {
            Text(Copy.notifications)
                .font(.footnote)
            Button("Allow notifications") {
                if requested {
                    dismiss()
                    UIApplication.shared.settings()
                } else {
                    Task {
                        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
                        requested = true
                        await check()
                    }
                }
            }
            .buttonStyle(.bordered)
            .font(.callout)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var face: some View {
        Section {
            Toggle.init(isOn: $authenticate) {
                Image(systemName: "faceid")
                    .symbolRenderingMode(.multicolor)
                    .font(.title)
                Text("Secure with Face ID")
                    .font(.callout)
            }
            .toggleStyle(SwitchToggleStyle(tint: .orange))
        }
    }
}
