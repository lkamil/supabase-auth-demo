//
//  NoteService.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation
import Supabase


// MARK: - NoteServiceRepresentable

protocol NotesServiceRepresentable {
    func fetchNote() async throws -> APINoteRowModel?
    func saveNote(content: String, color: String) async throws
}


// MARK: - NotesService

final class NotesService {

    private let client: SupabaseClient

    init(client: SupabaseClient) { self.client = client }
}


// MARK: - NotesService + NotesServiceRepresentable

extension NotesService: NotesServiceRepresentable {
    
    func fetchNote() async throws -> APINoteRowModel? {
            let rows: [APINoteRowModel] = try await client
                .from("notes")
                .select()
                .execute()
                .value
            return rows.first
        }

        func saveNote(content: String, color: String) async throws {
            let userId = try await client.auth.session.user.id
            let row = APINoteRowModel(userId: userId, content: content, color: color)
            try await client
                .from("notes")
                .upsert(row)
                .execute()
        }
}
