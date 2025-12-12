//
//  PlayListDetailView.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI

struct PlayListDetailView: View {
    
    @ObservedObject var playlist: PlayList
    
    var body: some View {
        List {
            HStack {
                Spacer()
                PlayListCoverView(urlString: playlist.coverImageUrlString, size: 200)
                Spacer()
            }
            .listRowBackground(Color.clear)

            Section {
                if !playlist.songsArray.isEmpty {
                    ForEach(playlist.songsArray) { song in
                        SongRow(song: song)
                    }
                } else {
                    Text("No songs available")
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            } header: {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%d", playlist.rating))
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Total duration:")
                        .fontWeight(.semibold)
                    Text(playlist.durationLengthText)
                }
            }
            .navigationTitle(playlist.name ?? "Unknown Playlist")
            .padding(.horizontal)
        }
    }
}
