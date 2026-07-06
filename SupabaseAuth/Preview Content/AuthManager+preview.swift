//
//  File.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//


import Auth

extension AuthManager {
    static var preview: AuthManager {
        AuthManager(
            service: MockAuthService(),
            mapper: AuthMapper()
        )
    }
}

final class MockAuthService: AuthServiceRepresentable {
    func signUp(email: String, password: String) async throws -> Session {
        fatalError("MockAuthService.signUp not implemented — this is preview-only")
    }
    func signIn(email: String, password: String) async throws -> Session {
        fatalError("MockAuthService.signIn not implemented — this is preview-only")
    }
    func signOut() async throws {}
    var authStateChanges: AsyncStream<(event: AuthChangeEvent, session: Session?)> {
        AsyncStream { $0.finish() }
    }
}
