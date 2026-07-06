//
//  NotesMapper.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation


// MARK: - NotesMapping

protocol NotesMapping {
    func map(row: APINoteRowModel?) -> NoteModel
}


// MARK: - NotesMapper

struct NotesMapper: NotesMapping {

    func map(row: APINoteRowModel?) -> NoteModel {
        NoteModel(
            content: row?.content ?? "",
            color: row.flatMap { NoteColor(rawValue: $0.color) } ?? .yellow
        )
    }
}
