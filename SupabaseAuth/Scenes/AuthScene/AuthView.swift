//
//  SignInView.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import SwiftUI

struct AuthView: View {

    @Environment(AuthManager.self) private var authManager

    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
    @State private var authConfig: Config = .signIn

    var body: some View {
        VStack(spacing: 16) {
            Text(authConfig.headline)
                .font(.largeTitle.bold())
            
            if authConfig == .signUp {
                TextField("Username", text: $username)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
            }

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            Button {
                Task {
                    switch authConfig {
                    case .signIn:
                        await signIn()
                    case .signUp:
                        await signUp()
                    }
                }
            } label: {
                if isSubmitting {
                    ProgressView()
                } else {
                    Text(authConfig.text)
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isSubmitting || email.isEmpty || password.isEmpty)

            
            HStack {
                Text(authConfig.question)
                
                Button(authConfig.toggleText) {
                    authConfig.toggle()
                }
            }
            .font(.footnote)
        }
        .padding()
    }
}


// MARK: - Helper

private extension AuthView {

    func signIn() async {
        errorMessage = nil
        isSubmitting = true
        defer { isSubmitting = false }

        do {
            try await authManager.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signUp() async {
        errorMessage = nil
        isSubmitting = true
        defer { isSubmitting = false }

        do {
            try await authManager.signUp(email: email, password: password, username: username)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
