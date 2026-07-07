//
//  NoteService.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation
import Supabase


// MARK: - NotesServiceRepresentable

protocol NotesServiceRepresentable {
    
    func fetchNotes() async throws -> [APINoteModel]
    func createNote() async throws -> APINoteModel
    func updateNote(id: UUID, content: String, color: String) async throws
    func deleteNote(id: UUID) async throws

    func uploadImage(data: Data, noteId: UUID) async throws -> APINoteImageModel
    func deleteImage(id: UUID, storagePath: String) async throws
    func imageURL(for storagePath: String) async throws -> URL
}


// MARK: - NotesService

final class NotesService {

    private let client: SupabaseClient

    init(client: SupabaseClient) { self.client = client }
}


// MARK: - NotesService + NotesServiceRepresentable

extension NotesService: NotesServiceRepresentable {
    
    func fetchNotes() async throws -> [APINoteModel] {
        try await client
            .from("notes")
            .select("*, note_images(*)")
            .order("created_at", ascending: false)
            .execute()
            .value
    }
    
    func createNote() async throws -> APINoteModel {
        let userId = try await client.auth.session.user.id
        let row = APINoteModel(
            id: UUID(),
            userId: userId,
            content: "",
            color: NoteColor.yellow.rawValue,
            noteImages: []
        )

        return try await client
            .from("notes")
            .insert(row)
            .select()
            .single()
            .execute()
            .value
    }
    
    func updateNote(id: UUID, content: String, color: String) async throws {
        try await client
        .from("notes")
        .update(["content": content, "color": color])
        .eq("id", value: id)
        .execute()
    }
    
    func deleteNote(id: UUID) async throws {
        try await client
            .from("notes")
            .delete()
            .eq("id", value: id)
            .execute()
    }
    
    func uploadImage(data: Data, noteId: UUID) async throws -> APINoteImageModel {
        
        let userId = try await client.auth.session.user.id
        let imageId = UUID()
        let path = "\(userId.uuidString.lowercased())/\(noteId)/\(imageId).jpg"

        try await client.storage
            .from("note-images")
            .upload(path, data: data, options: FileOptions(contentType: "image/jpeg"))

        let row = APINoteImageModel(
            id: imageId,
            noteId: noteId,
            userId: userId,
            storagePath: path
        )
        
        return try await client
            .from("note_images")
            .insert(row)
            .select()
            .single()
            .execute()
            .value
    }
    
    func deleteImage(id: UUID, storagePath: String) async throws {

        try await client.storage
            .from("note_images")
            .remove(paths: [storagePath])
        try await client
            .from("note_images")
            .delete()
            .eq("id", value: id)
            .execute()
    }

    /// the bucket it private, so images need a signed URL (temporary, expriting link)
    func imageURL(for storagePath: String) async throws -> URL {
        try await client.storage
            .from("note-images")
            .createSignedURL(path: storagePath, expiresIn: 3600)
    }
}
