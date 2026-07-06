//
//  SupabaseAuthApp.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import SwiftUI

@main
struct SupabaseAuthApp: App {
    
    @State private var authManager = AuthManager(
        service: AuthService(client: SupabaseConfig.authClient),
        mapper: AuthMapper()
    )
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(authManager)
        }
    }
}
