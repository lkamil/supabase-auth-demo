//
//  SettingsScene.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 07.07.26.
//

import SwiftUI

struct SettingsScene: View {
    
    @Environment(AuthManager.self) private var authManager
    @State private var viewState: ViewState = .idle
    
    var body: some View {
        
        switch viewState {
        case .idle:
            content

        case .isSigninOut:
            signOutView
    
        case .error(let description):
            errorView(description)
        }
    }
}


// MARK: - ViewState

extension SettingsScene {
    
    enum ViewState {
        case idle
        case isSigninOut
        case error(String)
    }
}


// MARK: - views

private extension SettingsScene {

    var content: some View {
        Button {
            Task {
                await signout()
            }
        } label: {
            Text("Sign Out")
        }
    }
    
    var signOutView: some View {
        HStack {
            ProgressView()
            Text("Signing Out...")
        }
    }
    
    func errorView(_ description: String) -> some View {
        ContentUnavailableView {
            Label("An error occured", systemImage: "exclamationmark.triangle")
        } description: {
            Text(description)
        }
    }
}


// MARK: - Helper

private extension SettingsScene {
    
    func signout() async {
        viewState = .isSigninOut
        
        defer { viewState = .idle }
        
        do {
            try await authManager.signOut()
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
}


// MARK: - Preview

#Preview {
    SettingsScene()
}
