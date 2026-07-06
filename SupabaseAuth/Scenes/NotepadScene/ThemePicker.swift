//
//  ThemePickerView.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import SwiftUI

struct ThemePicker: View {
    
    let selected: NoteColor
    let onSelect: (NoteColor) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(NoteColor.allCases, id: \.self) { option in
                Circle()
                    .fill(option.color)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle().stroke(selected == option ? Color.black : Color.gray, lineWidth: 1)
                    )
                    .onTapGesture { onSelect(option) }
            }
        }
    }
}


#Preview {
    ThemePicker(selected: .yellow) { _ in }
}
