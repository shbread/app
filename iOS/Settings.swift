import SwiftUI
import Secrets

struct Settings: View {
    @State private var requested = true
    @State private var enabled = true
    @Environment(\.dismiss) private var dismiss
    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = false
    @AppStorage(Defaults._tools.rawValue) private var tools = true
    @AppStorage(Defaults._spell.rawValue) private var spell = true
    @AppStorage(Defaults._correction.rawValue) private var correction = false
    
    var body: some View {
        List {
            header
            
//            if !requested || !enabled {
                notifications
//            }
            
            security
            edit
        }
        .toggleStyle(SwitchToggleStyle(tint: .orange))
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
                        .frame(width: 75)
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
            HStack {
                Image(systemName: "app.badge")
                    .symbolRenderingMode(.multicolor)
                    .font(.title)
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
        }
    }
    
    private var security: some View {
        Section("Security") {
            Toggle(isOn: $authenticate) {
                Image(systemName: "faceid")
                    .symbolRenderingMode(.multicolor)
                    .font(.title)
                Text("Secure with Face ID")
                    .font(.callout)
            }
        }
    }
    
    private var edit: some View {
        Section("Edit") {
            Toggle(isOn: $tools) {
                Image(systemName: "hammer")
                    .foregroundStyle(Color.accentColor)
                Text("Show toolbar above keyboard")
            }
            Toggle(isOn: $spell) {
                Image(systemName: "text.book.closed")
                    .foregroundStyle(Color.accentColor)
                Text("Spell checking")
            }
            Toggle(isOn: $correction) {
                Image(systemName: "ladybug")
                    .foregroundStyle(Color.accentColor)
                Text("Auto correction")
            }
        }
        .symbolRenderingMode(.palette)
        .font(.callout)
    }
}
