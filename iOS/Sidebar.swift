import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    @State private var requested = true
    
    var body: some View {
        GeometryReader { geo in
            if session.archive.secrets.isEmpty {
                Empty(session: $session)
            } else {
                List {
                    ForEach(session.filtered, id: \.self) { index in
                        NavigationLink(destination: Reveal(session: $session), isActive: .init(get: {
                            session.selected == index
                        }, set: {
                            session.selected = $0 ? index : nil
                        })) {
                            Item(secret: session.archive.secrets[index], max: .init(geo.size.width / 95))
                        }
                    }
                    
                    if !requested {
                        Section("Notifications") {
                            Text("""
We use notifications to display important and oportune messages, and only when you are actively using the app.

We will never send Push Notifications.

Your privacy is respected at all times.
""")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Button("Allow notifications") {
                                Task {
                                    _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
                                    requested = true
                                }
                            }
                            .buttonStyle(.bordered)
                            .font(.callout)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .privacySensitive()
                .listStyle(.sidebar)
                .searchable(text: $session.filter.search)
                .navigationBarTitle("Secrets", displayMode: .large)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Option(icon: session.filter.favourites ? "heart.fill" : "heart") {
                    session.filter.favourites.toggle()
                }
                
                Option(icon: "slider.horizontal.3") {
                    
                }
                
                Option(icon: "lock.square.stack") {
                    session.modal.send(.safe)
                }
                
                Option(icon: "plus", action: session.create)
            }
        }
        .task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            requested = settings.authorizationStatus != .notDetermined
        }
    }}
