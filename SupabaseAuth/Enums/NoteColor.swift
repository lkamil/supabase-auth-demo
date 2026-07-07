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
}


extension NoteColor {
    var value: Color {
        switch self {
        case .mint:
            Color.mint
            
        case .pink:
            Color.pink
            
        case .purple:
            Color.purple
            
        case .blue:
            Color.blue
            
        case .yellow:
            Color.yellow
        }
    }
}
