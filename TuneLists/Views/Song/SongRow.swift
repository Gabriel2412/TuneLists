//
//  SongRow.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI

struct SongRow: View {
    @ObservedObject var song: Song
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(song.name ?? "Unknown Song")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text(song.durationLengthText)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(song.artist?.name ?? "Unknown Artist")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
        }
    }
}
