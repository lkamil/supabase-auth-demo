//
//  UserModel.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation


struct UserModel: Equatable {
    let id: UUID
    let email: String?
    let username: String?
}
