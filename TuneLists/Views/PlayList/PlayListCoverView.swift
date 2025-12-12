//
//  PlayListCoverView.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI

struct PlayListCoverView: View {
    let urlString: String?
    let size: CGFloat
    
    var body: some View {
        Group {
            if let urlString = urlString, let url = URL(string: urlString) {
                // For efficiency we could use Kingfisher library for example
                // Wich will handle image caching for offline use and not reload each time. Or NSCache manually implemented.
                // Due time constrains I will use standard AsyncImage.
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.03, style: .continuous))
    }
    
    private var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: "music.note.list")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .padding(size * 0.2)
        }
    }
}

#Preview {
    PlayListCoverView(urlString: "https://www.groundguitar.com/wp-content/uploads/2024/02/Best-Album-Covers-of-All-Time-1024x768.jpg", size: 250)
}
