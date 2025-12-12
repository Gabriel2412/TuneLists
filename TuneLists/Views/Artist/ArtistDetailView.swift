//
//  ArtistDetailView.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI

struct ArtistDetailView: View {
    @ObservedObject var artist: Artist
    
    var body: some View {
        List {
            if artist.songsArray.isEmpty {
                Text("No songs available")
            }
            ForEach(artist.songsArray) { song in
                SongRow(song: song)
            }
        }
        .navigationTitle(artist.name ?? "Unknown Artist")
    }
}
