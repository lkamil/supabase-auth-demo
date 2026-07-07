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
            Color.Backgrounds.mint
            
        case .pink:
            Color.Backgrounds.pink
            
        case .purple:
            Color.Backgrounds.purple
            
        case .blue:
            Color.Backgrounds.blue
            
        case .yellow:
            Color.Backgrounds.yellow
        }
    }
}
