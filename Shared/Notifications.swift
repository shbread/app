import UserNotifications

enum Notifications {
    static func send(message: String) async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        guard settings.alertSetting == .enabled && settings.authorizationStatus == .authorized else { return }
        let content = UNMutableNotificationContent()
        content.body = message
        try? await UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
    }
}
