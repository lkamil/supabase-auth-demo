//
//  NotesListView.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 07.07.26.
//

import SwiftUI

struct NotesListScene: View {
    
    @State private var notesManager = NotesManager(
        service: NotesService(client: SupabaseConfig.client),
        mapper: NotesMapper()
    )
    
    @Environment(AuthManager.self) private var authManager
    
    var body: some View {
        NavigationStack {
            Group {
                if notesManager.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(notesManager.notes) { note in
                            NavigationLink(value: note.id) {
                                NoteRow(note: note)
                            }
                        }
                        .onDelete(perform: deleteNotes)
                    }
                    .listStyle(.inset)
                }
            }
            .navigationTitle(ownerTitle)
            .navigationDestination(for: UUID.self) { noteId in
                NoteDetailView(noteId: noteId)
                    .environment(notesManager)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await notesManager.addNote() }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .task {
            await notesManager.load()
        }
    }
}


// MARK: - Views

private extension NotesListScene {
    
    struct NoteRow: View {

        let note: NoteModel

        var body: some View {
            HStack {
    
                Circle()
                    .fill(note.color.value)
                    .frame(width: 12, height: 12)
    
                Text(note.content.isEmpty ? "Untitled" : note.content)
                    .lineLimit(1)

                Spacer()

                if !note.images.isEmpty {
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
            }
        }
    }
}


// MARK: - Helper

private extension NotesListScene {

    var ownerTitle: String {
        if let username = authManager.currentUser?.username {
            return "\(username)'s Notes"
        }
        return "Notes"
    }

    func deleteNotes(at offsets: IndexSet) {
        let idsToDelete = offsets.map { notesManager.notes[$0].id }
        Task {
            for id in idsToDelete {
                await notesManager.deleteNote(id: id)
            }
        }
    }
}
