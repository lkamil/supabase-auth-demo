//
//  HomeView.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(AuthManager.self) private var authManager
    @State private var isSigningOut = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome!")
                .font(.largeTitle.bold())

            if let email = authManager.currentUser?.email {
                Text(email)
                    .foregroundStyle(.secondary)
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
            

            Button(role: .destructive) {
                Task { await signOut() }
            } label: {
                if isSigningOut {
                    ProgressView()
                } else {
                    Text("Log Out")
                }
            }
            .buttonStyle(.bordered)
            .disabled(isSigningOut)
        }
        .padding()
    }
}


// MARK: - Helper

private extension HomeView {

    func signOut() async {
        errorMessage = nil
        isSigningOut = true
        defer { isSigningOut = false }

        do {
            try await authManager.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}


// MARK: - Preview

#Preview {
    HomeView()
        .environment(AuthManager.preview)
}
