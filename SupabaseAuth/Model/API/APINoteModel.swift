//
//  APINoteModel.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation

struct APINoteModel: Codable {

    let id: UUID
    let userId: UUID
    let content: String
    let color: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case content
        case color
    }
}
