//
//  DashboardView.swift
//  CloudKitIsAMagic
//
//  Created by Konstantin Kolosov on 05.06.2024.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(animation: .default) var swiftDataNotes: [SwiftDataNote]
    @FetchRequest(sortDescriptors: [], animation: .default) var coreDataNotes: FetchedResults<CoreDataNote>

    @Environment(\.managedObjectContext) var coreDataContext
    @Environment(\.modelContext) var swiftDataContext

    var body: some View {
        List {
            swiftDataSection
            coreDataSection
        }
    }

    @ViewBuilder
    private var swiftDataSection: some View {
        Section {
            ForEach(swiftDataNotes) { note in
                HStack {
                    Image(systemName: "circle.fill")
                        .imageScale(.small)
                        .foregroundStyle(Color(NoteColor(rawValue: note.colorIndex)!.colorRepresentation))
                    Text(note.title)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button("Delete") { deleteSwiftDataNote(note) }
                        .tint(.red)
                }
            }
        } header: {
            Text("SwiftData Notes")
        }
    }

    @ViewBuilder
    private var coreDataSection: some View {
        Section {
            ForEach(coreDataNotes) { note in
                HStack {
                    Image(systemName: "circle.fill")
                        .imageScale(.small)
                        .foregroundStyle(Color(NoteColor(rawValue: Int(note.colorIndex))!.colorRepresentation))
                    Text(note.title ?? "")
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button("Delete") { deleteCoreDataNote(note) }
                        .tint(.red)
                }
            }
        } header: {
            Text("CoreData Notes")
        }
    }

    private func deleteSwiftDataNote(_ note: SwiftDataNote) {
        swiftDataContext.delete(note)
        try? swiftDataContext.save()
    }

    private func deleteCoreDataNote(_ note: CoreDataNote) {
        coreDataContext.delete(note)
        try? coreDataContext.save()
    }
}

#Preview {
    UINavigationController(rootViewController: ViewController())
}
