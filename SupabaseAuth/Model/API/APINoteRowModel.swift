//
//  APINoteRowModel.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation

struct APINoteRowModel: Codable {

    let userId: UUID
    let content: String
    let color: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case content
        case color
    }
}
