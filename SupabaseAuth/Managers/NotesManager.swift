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
    
    private(set) var note = NoteModel(content: "", color: .yellow)
    private(set) var isLoading = false

    private let service: NotesServiceRepresentable
    private let mapper: NotesMapping
    private var saveTask: Task<Void, Never>?

    init(service: NotesServiceRepresentable, mapper: NotesMapping) {
        self.service = service
        self.mapper = mapper
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let row = try await service.fetchNote()
            note = mapper.map(row: row)
        } catch {
            print("Failed to load note:", error)
        }
    }

    func updateContent(_ newContent: String) {
        note.content = newContent
        saveTask?.cancel()
        saveTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(600))
            guard !Task.isCancelled, let self else { return }
            do {
                try await self.service.saveNote(content: self.note.content, color: self.note.color.rawValue)
            } catch {
                print("Failed to save note:", error)
            }
        }
    }

    func updateColor(_ newColor: NoteColor) {
        note.color = newColor
        Task {
            do {
                try await service.saveNote(content: note.content, color: note.color.rawValue)
            } catch {
                print("Failed to save color:", error)
            }
        }
    }

    func reset() {
        saveTask?.cancel()
        note = NoteModel(content: "", color: .yellow)
    }
}
