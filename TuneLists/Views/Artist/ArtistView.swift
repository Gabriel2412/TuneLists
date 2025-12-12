//
//  ArtistView.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI

struct ArtistView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Artist.name, ascending: true)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    var body: some View {
        NavigationView {
            List(artists) { artist in
                NavigationLink(destination: ArtistDetailView(artist: artist)) {
                    Text(artist.name ?? "Unknown Artist")
                        .padding(.vertical)
                }
            }
            .navigationTitle("Artists")
        }
    }
}
