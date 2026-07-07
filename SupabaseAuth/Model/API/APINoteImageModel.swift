//
//  APINoteImageModel.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 07.07.26.
//

import Foundation

import Foundation

struct APINoteImageModel: Codable {

    let id: UUID
    let noteId: UUID
    let userId: UUID
    let storagePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case noteId = "note_id"
        case userId = "user_id"
        case storagePath = "storage_path"
    }
}
