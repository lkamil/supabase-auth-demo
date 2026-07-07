//
//  HomeView.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 07.07.26.
//

import SwiftUI

struct HomeScene: View {
    
    enum TabSelection: Hashable {
        case notes
        case settings
    }
    
    @State var currentTab: TabSelection = .notes


    var body: some View {
        TabView(selection: $currentTab) {
            Tab("Notes", systemImage: "pencil.and.list.clipboard", value: .notes) {
                NotesListScene()
            }
            
            Tab("Settings", systemImage: "gearshape", value: .settings) {
                SettingsScene()
            }
        }
    }
}

#Preview {
    HomeScene()
}
