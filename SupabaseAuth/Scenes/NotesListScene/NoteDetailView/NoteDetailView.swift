//
//  NoteDetailView.swift
//  SupabaseAuth
//
//  Created by Laila Kamil on 07.07.26.
//

import SwiftUI
import PhotosUI

struct NoteDetailView: View {
    
    @Environment(NotesManager.self) private var notesManager
    let noteId: UUID

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isUploadingPhoto = false
    
    private var note: NoteModel? {
        notesManager.notes.first { $0.id == noteId }
    }
    
    
    // MARK: - body
    
    var body: some View {
        switch viewState {
        case .loading:
            ProgressView()

        case .loaded(let note):
            content(for: note)

        case .error:
            errorView
        }
    }
}


// MARK: - ViewState

extension NoteDetailView {
    
    enum ViewState {
        case loading
        case loaded(note: NoteModel)
        case error
    }

    private var viewState: ViewState {
        if let note {
            return .loaded(note: note)
        } else if notesManager.isLoading {
            return .loading
        } else {
            return .error
        }
    }
}


// MARK: - Views

private extension NoteDetailView {
    
    func content(for note: NoteModel) -> some View {
        VStack {
            ImagesStrip(images: note.images) { imageId in
                Task { await notesManager.deleteImage(id: imageId, from: noteId) }
            }

            TextEditor(text: Binding(
                get: { note.content },
                set: { newValue in
                    notesManager.updateContent(newValue, for: noteId)
                }
            ))
            .scrollContentBackground(.hidden)
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            ToolbarItem(placement: .bottomBar) {
                ThemePicker(selected: note.color) { newColor in
                    notesManager.updateColor(newColor, for: noteId)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    if isUploadingPhoto {
                        ProgressView()
                    } else {
                        Image(systemName: "photo.badge.plus")
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: selectedPhoto) { _, newItem in
            guard let newItem else { return }
            Task { await upload(newItem) }
        }
        .background(note.color.value)
    }

    
    var errorView: some View {
        ContentUnavailableView {
            Label("Note not found", systemImage: "exclamationmark.triangle")
        } description: {
            Text("An error occured while trying to load the note.")
        }
    }

    struct ImagesStrip: View {
        let images: [NoteImageModel]
        var onDelete: (UUID) -> Void
        
        var body: some View {
            if !images.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images) { image in
                            AsyncImage(url: image.url) { phase in
                                switch phase {
                                case .success(let img):
                                    img.resizable().scaledToFill()
                                default:
                                    Color.gray.opacity(0.2)
                                }
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    onDelete(image.id)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.white, .black.opacity(0.6))
                                }
                                .padding(4)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    struct ButtonsPanel: View {
        var color: NoteColor
        var isUploadingPhoto: Bool
        @Binding var selectedPhoto: PhotosPickerItem?
        var onColorChange: (NoteColor) -> Void

        var body: some View {
            HStack {
                ThemePicker(selected: color) { newColor in
                    onColorChange(newColor)
                }

                Spacer()

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    if isUploadingPhoto {
                        ProgressView()
                    } else {
                        Image(systemName: "photo.badge.plus")
                    }
                }
                .disabled(isUploadingPhoto)
            }
            .padding()
        }
    }
}


// MARK: - Helpers

private extension NoteDetailView {
    
    func upload(_ item: PhotosPickerItem) async {
        isUploadingPhoto = true
        defer {
            isUploadingPhoto = false
            selectedPhoto = nil
        }
        do {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            await notesManager.addImage(data: data, to: noteId)
        } catch {
            print("Failed to load photo:", error)
        }
    }
}
