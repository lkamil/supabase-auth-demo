//
//  ContentView.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import SwiftUI

struct RootView: View {

    @Environment(AuthManager.self) private var authManager
    
    var body: some View {
        
        if authManager.isLoading {
            ProgressView()
        } else if authManager.currentUser != nil {
            HomeScene()
                .environment(authManager)
        } else {
            AuthView()
        }
    }
}


// MARK: - Preview

#Preview {
    RootView()
}
