//
//  ContentView.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(TuneListService.self) var tuneListService: TuneListService?
    
    var body: some View {
        TabView {
            PlayListView()
                .tabItem {
                    Label("Playlists", systemImage: "music.note.list")
                }

            ArtistView()
                .tabItem {
                    Label("Artists", systemImage: "person.3.sequence")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .overlay {
            ErrorToastListView()
        }
        .task {
            try? await tuneListService?.syncPlayLists()
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environment(ErrorService())
        .environment(TuneListService(persistenceController: PersistenceController.preview, networkLayer: NetworkMockedLayer()))
}
