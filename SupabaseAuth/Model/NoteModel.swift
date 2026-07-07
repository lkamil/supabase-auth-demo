//
//  NoteModel.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation

struct NoteModel: Equatable, Identifiable {
    
    var id: UUID
    var content: String
    var color: NoteColor
    var images: [NoteImageModel]
}

struct NoteImageModel: Equatable, Identifiable {
    var id: UUID
    var url: URL
    var storagePath: String
}
