//
//  SupabaseConfig.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation
import Supabase
	


enum SupabaseConfig {
    static var client: SupabaseClient = {
        guard
            let urlString = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
            let url = URL(string: urlString),
            let key = Bundle.main.infoDictionary?["SUPABASE_PUBLISHABLE_KEY"] as? String
        else {
            fatalError("Missing Supabase configuration in Info.plist")
        }
        return SupabaseClient(supabaseURL: url, supabaseKey: key)
    }()
}
