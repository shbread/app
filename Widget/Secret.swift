import SwiftUI
import WidgetKit

@main struct Secret: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Secret", provider: Provider(), content: Content.init(entry:))
            .configurationDisplayName("Secret")
            .description("Quick add a secret")
            .supportedFamilies([.systemSmall])
    }
}

private struct Content: View {
    let entry: Entry
    
    var body: some View {
        ZStack {
            Image(systemName: "lock")
                .font(.largeTitle)
        }
        .widgetURL(URL(string: "shortbread://")!)
    }
}

private struct Provider: TimelineProvider {
    func placeholder(in: Context) -> Entry {
        .shared
    }

    func getSnapshot(in: Context, completion: @escaping (Entry) -> ()) {
        completion(.shared)
    }

    func getTimeline(in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(.init(entries: [.shared], policy: .never))
    }
}

private struct Entry: TimelineEntry {
    static let shared = Self()

    let date = Date()
}
