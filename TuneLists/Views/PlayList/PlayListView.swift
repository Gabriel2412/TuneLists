//
//  PlayListView.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 12.12.2025.
//

import SwiftUI

struct PlayListView: View {
    @Environment(ErrorService.self) var errorService: ErrorService?
    @Environment(TuneListService.self) var tuneListService: TuneListService?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PlayList.createdAt, ascending: true)],
        animation: .default)
    private var playlists: FetchedResults<PlayList>
    @State private var loading: Bool = false
    var body: some View {
        Group {
            #if os(iOS) && !targetEnvironment(macCatalyst)
            NavigationStack {
                listViewContent
            }
            #elseif os(macOS) || targetEnvironment(macCatalyst)
            NavigationSplitView {
                listViewContent
                    .frame(minWidth: 250, idealWidth: 800)

            } detail: {
                Text("Select an item")
            }
            #else
            NavigationView {
                listViewContent
                Text("Select an item")
            }
            #endif
        }
        .task {
            do {
                try await tuneListService?.syncPlayLists()
            } catch {
                errorService?.showError(TuneListError.syncFailed)
            }
        }
    }

    private var listViewContent: some View {
        List {
            ForEach(playlists) { playlist in
                NavigationLink {
                    PlayListDetailView(playlist: playlist)
                } label: {
                    PlayListRow(playlist: playlist)
                        .frame(minWidth: 250, idealWidth: 700)
                }
            }
            .onDelete { offsets in
                Task {
                    await deleteItems(offsets: offsets)
                }
            }
        }
        .animation(.default, value: playlists.count) // Due CoreData FetchedResults not being equatable, we can use the list change, as this animation is for the deletion.
        .navigationTitle("PlayLists")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        do {
                            loading = true
                            try await Task.sleep(for: .seconds(2))
                            try await tuneListService?.saveNewPlaylist(title: "New Playlist")
                        } catch {
                            print(error)
                            errorService?.showError(TuneListError.newPlaylistFailed)
                        }
                        loading = false
                    }
                } label: {
                    if !loading {
                        Label("New PlayList" , systemImage: "plus")
                    } else {
                        ProgressView()
                    }
                }
            }
        }
    }
        
    private func deleteItems(offsets: IndexSet) async {
        for index in offsets {
            do {
                let item = playlists[index]
                try await tuneListService?.deletePlaylist(item)
            } catch {
                errorService?.showError(TuneListError.deleteItemFailed)
            }
        }
    }
}
