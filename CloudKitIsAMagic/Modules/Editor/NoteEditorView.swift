//
//  NoteEditorView.swift
//  CloudKitIsAMagic
//
//  Created by Konstantin Kolosov on 05.06.2024.
//

import SwiftUI
import SwiftData

struct NoteEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var coreDataContext
    @Environment(\.modelContext) var swiftDataContext

    @State var title: String = ""
    @State var selectedColorIndex: Int = 0

    @State var error: VerifyError?
    @State var errorAlertIsPresented: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                editorView
                Spacer()
                addButtons
            }
            .navigationTitle("Create a new Note")
            .alert(isPresented: $errorAlertIsPresented, error: error) {
                Button("Ok") { }
            }
        }
    }

    @ViewBuilder
    private var editorView: some View {
        VStack {
            TextField("Start typing here", text: $title)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)
            colorsView
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var colorsView: some View {
        ScrollView {
            HStack(spacing: 0) {
                ForEach(NoteColor.allCases, id: \.id) { color in
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(color.colorRepresentation))
                        .overlay {
                            if color.rawValue == selectedColorIndex {
                                Circle()
                                    .stroke(Color(color.colorRepresentation), lineWidth: 1.5)
                                    .frame(width: 28, height: 28)
                            }
                        }
                        .onTapGesture {
                            withAnimation { self.selectedColorIndex = color.rawValue }
                        }
                        .padding(.horizontal, 8)
                }
                Spacer()
            }
            .frame(height: 30)
        }
    }

    @ViewBuilder
    private var addButtons: some View {
        VStack {
            Divider()
            HStack {
                Button("Add CD Note", systemImage: "tray.and.arrow.down", action: addCoreDataNote)
                Button("Add SD Note", systemImage: "swiftdata", action: addSwiftDataNote)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.bottom)
    }

    private func verify() throws {
        guard !title.isEmpty else { throw VerifyError.titleIsMissing }
    }

    private func addCoreDataNote() {
        do {
            try verify()
            let newCoreDataNote = CoreDataNote(context: coreDataContext)
            newCoreDataNote.title = title
            newCoreDataNote.colorIndex = Int16(selectedColorIndex)
            newCoreDataNote.id = .init()
            try? coreDataContext.save()
            NotificationCenter.default.post(name: .dataFlowUpdated, object: nil)
            dismiss()
        } catch {
            self.error = error as? VerifyError
        }
    }

    private func addSwiftDataNote() {
        do {
            try verify()
            let newSwiftDataNote = SwiftDataNote(title: title, colorIndex: selectedColorIndex)
            swiftDataContext.insert(newSwiftDataNote)
            try? swiftDataContext.save()
            NotificationCenter.default.post(name: .dataFlowUpdated, object: nil)
            dismiss()
        } catch {
            self.error = error as? VerifyError
        }
    }
}

enum VerifyError: LocalizedError {
    case titleIsMissing

    var errorDescription: String? {
        "Enter title, please"
    }
}

#Preview {
    NoteEditorView()
        .modelContainer(.current)
        .environment(\.managedObjectContext, .current)
}
