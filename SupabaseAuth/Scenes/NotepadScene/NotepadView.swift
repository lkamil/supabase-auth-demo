//
//  NotpadView.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 06.07.26.
//

import SwiftUI

struct NotepadView: View {

    @Environment(AuthManager.self) private var authManager

    @State private var errorMessage: String?
    @State private var viewState: ViewState = .idle
    @State private var notesManager = NotesManager(
        service: NotesService(client: SupabaseConfig.client),
        mapper: NotesMapper()
    )
    
    
    // MARK: - body

    var body: some View {

        ZStack {
            notesManager.note.color.value
                .ignoresSafeArea()
            
            VStack {
                
                ownerTag
         
                NoteEditorView()
                
                ButtonsPanel(viewState: viewState) {
                    Task {
                        await signOut()
                    }
                }
            }
            .environment(notesManager)
        }
        .task {
            await notesManager.load()
        }
        .onChange(of: authManager.currentUser) { oldValue, newValue in
            guard newValue == nil else { return }
            notesManager.reset()
        }
    }
}


// MARK: - ViewState

extension NotepadView {
    enum ViewState {
        case isSigningOut
        case idle
    }
}


// MARK: - Views

private extension NotepadView {
    
    struct NoteEditorView: View {

        @Environment(NotesManager.self) private var notesManager
        
        var body: some View {
            if notesManager.isLoading {
                ProgressView()
            } else {
                TextEditor(text: Binding(
                    get: { notesManager.note.content },
                    set: { newValue in
                        notesManager.updateContent(newValue)
                    }
                ))
                .scrollContentBackground(.hidden)
                .padding()
            }
        }
    }
    
    @ViewBuilder
    var ownerTag: some View {
        if let email = authManager.currentUser?.email {
            Text("\(email)'s Notepad")
                .foregroundStyle(.secondary)
                .font(.footnote)
        }
    }
    
        
    struct ButtonsPanel: View {
        
        @Environment(NotesManager.self) private var notesManager
        
        var viewState: ViewState
        var onSignOut: () -> Void
        
        
        var body: some View {
            HStack {
                
                ThemePicker(selected: notesManager.note.color) { newColor in
                    notesManager.updateColor(newColor)
                }
                
                Spacer()
                
                Button() {
                    onSignOut()
                } label: {
                    switch viewState {
                    case .isSigningOut:
                        ProgressView()
                    default:
                        Text("Log Out")
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}


// MARK: - Helper

private extension NotepadView {
    
    func signOut() async {
        errorMessage = nil
        viewState = .isSigningOut
        defer { viewState = .idle }

        do {
            try await authManager.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
