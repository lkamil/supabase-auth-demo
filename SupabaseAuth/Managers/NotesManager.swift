//
//  NotesManager.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class NotesManager {
    
    private(set) var notes: [NoteModel] = []
    private(set) var isLoading = false
    
    private let service: NotesServiceRepresentable
    private let mapper: NotesMapping
    private var saveTasks: [UUID: Task<Void, Never>] = [:]
    
    init(service: NotesServiceRepresentable, mapper: NotesMapping) {
        self.service = service
        self.mapper = mapper
    }
}


extension NotesManager {

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let rows = try await service.fetchNotes()
            var loaded: [NoteModel] = []
            for row in rows {
                let images = try await loadImages(noteId: row.id)
                loaded.append(mapper.map(row: row, images: images))
            }
            notes = loaded
        } catch {
            print("Failed to load notes:", error)
        }
    }
    
    func addNote() async {
        do {
            let row = try await service.createNote()
            notes.insert(mapper.map(row: row, images: []), at: .zero)
        } catch {
            print("Failed to create note:", error)
        }
    }
    
    func deleteNote(id: UUID) async {
        do {
            try await service.deleteNote(id: id)
            notes.removeAll { $0.id == id }
            saveTasks[id]?.cancel()
            saveTasks[id] = nil
        } catch {
            print("Failed to delete note:", error)
        }
    }
    
    /// updateContent with debounce for each note
    func updateContent(_ newContent: String, for noteId: UUID) {

        guard let index = notes.firstIndex(where: { $0.id == noteId }) else { return }
        notes[index].content = newContent

        saveTasks[noteId]?.cancel()
        saveTasks[noteId] = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(600))
            guard !Task.isCancelled, let self else { return }
            do {
                try await self.service.updateNote(
                    id: noteId,
                    content: newContent,
                    color: self.notes[index].color.rawValue
                )
            } catch {
                print("Failed to save note:", error)
            }
        }
    }
    
    func updateColor(_ newColor: NoteColor, for noteId: UUID) {

        guard let index = notes.firstIndex(where: { $0.id == noteId }) else { return }
        notes[index].color = newColor
        do {
            Task {
                do {
                    try await service.updateNote(
                        id: noteId,
                        content: notes[index].content,
                        color: newColor.rawValue
                    )
                } catch {
                    print("Failed to save color:", error)
                }
            }
        }
    }
    
    /// signed image urls expire after one hour. If the user leaves the app open longer than that the images will have a 403 error
    func addImage(data: Data, to noteId: UUID) async {

        guard let index = notes.firstIndex(where: { $0.id == noteId }) else { return }
    
        do {
            let row = try await service.uploadImage(data: data, noteId: noteId)
            let url = try await service.imageURL(for: row.storagePath)
            notes[index].images.append(NoteImageModel(
                id: row.id,
                url: url,
                storagePath: row.storagePath)
            )
        } catch {
            print("Failed to upload image:", error)
        }
    }
    
    func deleteImage(id: UUID, from noteId: UUID) async {

        guard let noteIndex = notes.firstIndex(where: { $0.id == noteId }),
              let image = notes[noteIndex].images.first(where: { $0.id == id }) else { return }

        do {
            try await service.deleteImage(id: id, storagePath: image.storagePath)
            notes[noteIndex].images.removeAll { $0.id == id }
        } catch {
            print("Failed to delete image:", error)
        }
    }

    func reset() {

        saveTasks.values.forEach { $0.cancel() }
        saveTasks.removeAll()
        notes = []
    }
}


// MARK: - Helpers

private extension NotesManager {

    func loadImages(noteId: UUID) async throws -> [NoteImageModel] {
        let rows = try await service.fetchImages(noteId: noteId)
        var images: [NoteImageModel] = []
        for row in rows {
            let url = try await service.imageURL(for: row.storagePath)
            images.append(NoteImageModel(id: row.id, url: url, storagePath: row.storagePath))
        }
        return images
    }
}
