//
//  SupabaseConfig.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation
import Auth


enum SupabaseConfig {
    static var authClient: AuthClient = {
        guard
            let urlString = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
            let projectURL = URL(string: urlString),
            let anonKey = Bundle.main.infoDictionary?["SUPABASE_PUBLISHABLE_KEY"] as? String
        else {
            fatalError("Missing Supabase configuration in Info.plist")
        }

        return AuthClient(
            url: projectURL.appendingPathComponent("auth/v1"),
            headers: ["apikey": anonKey],
            flowType: .pkce,
            localStorage: KeychainLocalStorage(service: "com.yourapp.bundleid.supabase"),
            logger: nil
        )
    }()
}
