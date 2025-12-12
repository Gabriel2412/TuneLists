//
//  PlayListRow.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI

struct PlayListRow: View {
    
    @ObservedObject var playlist: PlayList
 
    var body: some View {
        HStack(spacing: 16) {
            PlayListCoverView(urlString: playlist.coverImageUrlString, size: 60)
            VStack(alignment: .leading, spacing: 6) {
                Text(playlist.name ?? "Unknown Playlist")
                    .font(.headline)
                HStack {
                    Text("Total songs:")
                        .fontWeight(.bold)
                    Text("\(playlist.songs?.count ?? 0)")
                }
                HStack {
                    Text("Length:")
                        .fontWeight(.bold)
                    Text(playlist.durationLengthText)
                }
            }
            Spacer()

            HStack(spacing: 4) {
                Text("\(playlist.rating)")
                    .fontWeight(.semibold)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding()
    }
}
