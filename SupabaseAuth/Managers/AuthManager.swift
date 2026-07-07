//
//  AuthManager.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import SwiftUI
import Auth

@MainActor
@Observable final class AuthManager {
    
    private(set) var currentUser: UserModel?
    private(set) var isLoading = true

    private let service: AuthServiceRepresentable
    private let mapper: AuthMapping
    private var listenTask: Task<Void, Never>?

    init(service: AuthServiceRepresentable, mapper: AuthMapping) {
        self.service = service
        self.mapper = mapper
        observeAuthState()
    }

    func signUp(email: String, password: String, username: String) async throws {
        let session = try await service.signUp(email: email, password: password,  username: username)
        currentUser = mapper.map(session: session)
    }

    func signIn(email: String, password: String) async throws {
        let session = try await service.signIn(email: email, password: password)
        currentUser = mapper.map(session: session)
    }

    func signOut() async throws {
        try await service.signOut()
        currentUser = nil
    }
}


// MARK: - Helpers

private extension AuthManager {
    
    func observeAuthState() {
        listenTask = Task { [weak self] in
            guard let self else { return }
            for await (_, session) in service.authStateChanges {
                self.currentUser = session.map(self.mapper.map)
                self.isLoading = false
            }
        }
    }
}
