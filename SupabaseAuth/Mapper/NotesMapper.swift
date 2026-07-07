//
//  NotesMapper.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation


// MARK: - NotesMapping

protocol NotesMapping {
    func map(row: APINoteModel, images: [NoteImageModel]) -> NoteModel
}


// MARK: - NotesMapper

struct NotesMapper: NotesMapping {

    func map(row: APINoteModel, images: [NoteImageModel]) -> NoteModel {
        NoteModel(
            id: row.id,
            content: row.content,
            color: NoteColor(rawValue: row.color) ?? .yellow,
            images: images
        )
    }
}
