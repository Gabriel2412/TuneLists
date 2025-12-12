//
//  Artist+Ext.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import CoreData
import Foundation

extension Artist {
    static func importData(from dtos: [ArtistJSON], in context: NSManagedObjectContext) throws {
        // Flatten all nested songs to import them efficiently first
        let allSongs = dtos.flatMap { $0.songs }
        
        // This returns us the actual Core Data objects we just created/updated
        let songLookup = try Song.importData(from: allSongs, in: context)
        
        // Prepare Artist Fetch
        let artistIds = dtos.map { $0.id }
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", artistIds)
        let existingArtists = try context.fetch(request)
        
        var artistDict = Dictionary(uniqueKeysWithValues: existingArtists.map { ($0.id!, $0) })
        
        // Upsert Artists & Link Relationships
        for dto in dtos {
            let artist = artistDict[dto.id] ?? Artist(context: context)
            artist.id = dto.id
            artist.name = dto.name
            let songEntities = dto.songs.compactMap { songLookup[$0.id] }
            artist.songs = NSSet(array: songEntities)
            artistDict[dto.id] = artist
        }
    }
    
    var songsArray: [Song] {
        let set = songs as? Set<Song> ?? []
        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }
}
