//
//  AuthService.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation
import Auth


// MARK: - AuthServiceRepresentable

protocol AuthServiceRepresentable {
    
    var authStateChanges: AsyncStream<(event: AuthChangeEvent, session: Session?)> { get }
    
    func signIn(email: String, password: String) async throws -> Session
    func signOut() async throws
    func signUp(email: String, password: String) async throws -> Session
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
    
    private let client: AuthClient

    init(client: AuthClient) {
        self.client = client
    }
}


// MARK: - AuthService + AuthServiceRepresentable

extension AuthService: AuthServiceRepresentable {
    
    var authStateChanges: AsyncStream<(event: AuthChangeEvent, session: Session?)> {
        client.authStateChanges
    }
    
    func signIn(email: String, password: String) async throws -> Session {
        try await client.signIn(email: email, password: password)
    }
    
    func signOut() async throws {
        try await client.signOut()
    }
    
    func signUp(email: String, password: String) async throws -> Session {
        let response = try await client.signUp(email: email, password: password)
        // signUp returns a session only if email confirmation is off;
        // handle nil session upstream in the Manager if you require confirmation
        guard let session = response.session else {
            throw AuthServiceError.confirmationRequired
        }
        return session
    }
}
