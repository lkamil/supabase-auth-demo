//
//  AuthService.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation
import Supabase


// MARK: - AuthServiceRepresentable

protocol AuthServiceRepresentable {
    
    var authStateChanges: AsyncStream<(event: AuthChangeEvent, session: Session?)> { get }
    
    func signIn(email: String, password: String) async throws -> Session
    func signOut() async throws
    func signUp(email: String, password: String, username: String) async throws -> Session
    func updateUsername(_ username: String) async throws
}


// MARK: - AuthServiceError

enum AuthServiceError: Error {
    case confirmationRequired
    
    var errorDescription: String? {
        switch self {
        case .confirmationRequired:
            return "Check your email to confirm your account before signing in."
        }
    }
}


// MARK: - AuthService

final class AuthService {
    
    private let client: SupabaseClient

    init(client: SupabaseClient) {
        self.client = client
    }
}


// MARK: - AuthService + AuthServiceRepresentable

extension AuthService: AuthServiceRepresentable {
    
    var authStateChanges: AsyncStream<(event: AuthChangeEvent, session: Session?)> {
        client.auth.authStateChanges
    }
    
    func signIn(email: String, password: String) async throws -> Session {
        try await client.auth.signIn(email: email, password: password)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func signUp(email: String, password: String, username: String) async throws -> Session {

        let response = try await client.auth.signUp(
            email: email,
            password: password,
            data: ["username": .string(username)]
        )
        // signUp returns a session only if email confirmation is off;
        // handle nil session upstream in the Manager if you require confirmation
        guard let session = response.session else {
            throw AuthServiceError.confirmationRequired
        }
        return session
    }
    
    func updateUsername(_ username: String) async throws {

        let userId = try await client.auth.session.user.id
        
        try await client
            .from("profiles")
            .upsert(["id": userId.uuidString.lowercased(), "username": username])
            .execute()
    }
}
