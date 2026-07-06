//
//  NoteColor.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import SwiftUI

enum NoteColor: String, CaseIterable, Codable {

    case mint
    case pink
    case purple
    case blue
    case yellow

    var color: Color {
        switch self {
        case .mint: Color(red: 0.9, green: 1, blue: 0.94)
        case .pink: Color(red: 1.0, green: 0.92, blue: 0.97)
        case .purple: Color(red: 0.96, green: 0.91, blue: 1.0)
        case .blue: Color(red: 0.88, green: 0.98, blue: 1.0)
        case .yellow: Color(red: 1.0, green: 1, blue: 0.88)
        }
    }
}
