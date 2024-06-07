//
//  NotesWidget.swift
//  NotesWidget
//
//  Created by Konstantin Kolosov on 07.06.2024.
//

import WidgetKit
import SwiftUI
import CoreData
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct NotesWidgetEntryView: View {
    @Query(animation: .default) var swiftDataNotes: [SwiftDataNote]
    @FetchRequest(sortDescriptors: [], animation: .default) var coreDataNotes: FetchedResults<CoreDataNote>

    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Label("SwiftData", systemImage: "swiftdata")
            Text("Notes: \(swiftDataNotes.count)")
            if let swiftDataNote = swiftDataNotes.first {
                Text("\(swiftDataNote.title)")
            }

            Divider()

            Label("CoreData", systemImage: "tray.full.fill")
            Text("Notes: \(coreDataNotes.count)")
            if let coreDataNote = coreDataNotes.first {
                Text("\(coreDataNote.title ?? "")")
            }
        }
        .font(.callout)
    }
}

struct NotesWidget: Widget {
    let kind: String = "NotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NotesWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .environment(\.managedObjectContext, .current)
                .modelContainer(.current)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    NotesWidget()
} timeline: {
    SimpleEntry(date: .now)

}
