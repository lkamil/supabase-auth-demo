//
//  AuthMapper.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import Foundation
import Auth


// MARK: - AuthMapping

protocol AuthMapping {
    func map(session: Session) -> UserModel
}


// MARK: - AuthMapper

struct AuthMapper: AuthMapping {
    
    func map(session: Session) -> UserModel {
        UserModel(id: session.user.id, email: session.user.email)
    }
}
