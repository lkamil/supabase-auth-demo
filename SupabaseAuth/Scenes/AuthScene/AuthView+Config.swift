//
//  AuthConfig.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation


// MARK: - Config

extension AuthView {
    enum Config {
        case signIn
        case signUp
    }
}


// MARK: - toggle

extension AuthView.Config {
    
    mutating func toggle() {
        self = self == .signIn ? .signUp : .signIn
    }
}


// MARK: - Config + strings

extension AuthView.Config {
    
    var headline: String {
        switch self {
        case .signIn:
            "Sign In"
            
        case .signUp:
            "Create Account"
        }
    }
    
    var text: String {
        switch self {
        case .signIn:
            "Sign In"
            
        case .signUp:
            "Sign Up"
        }
    }
    
    var toggleText: String {
        switch self {
        case .signIn:
            "Don't have an account? Sign Up"

        case .signUp:
            "Already have an account? Sign In"
        }
    }
}

