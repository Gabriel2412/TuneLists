//
//  PlayList+Ext.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//
import CoreData
import Foundation

extension PlayList {
    
    static func importData(from dtos: [PlaylistJSON], in context: NSManagedObjectContext) throws {
        
        let playlistIds = dtos.map { $0.id }
        let request: NSFetchRequest<PlayList> = PlayList.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", playlistIds)
        let existingPlaylists = try context.fetch(request)
        
        var playlistDict = Dictionary(uniqueKeysWithValues: existingPlaylists.map { ($0.id!, $0) })
        
        // Identify ALL Song IDs referenced across these playlists
        let allReferencedSongIds = Set(dtos.flatMap { $0.songs })
        
        // Fetch the actual Song Entities for these IDs
        let songRequest: NSFetchRequest<Song> = Song.fetchRequest()
        songRequest.predicate = NSPredicate(format: "id IN %@", allReferencedSongIds)
        let songResults = try context.fetch(songRequest)
        
        let songLookup = Dictionary(uniqueKeysWithValues: songResults.map { ($0.id!, $0) })
        
        // Loop Playlists and Link
        for dto in dtos {
            let playlist = playlistDict[dto.id] ?? PlayList(context: context)
            playlist.id = dto.id
            playlist.name = dto.name
            playlist.rating = Int16(dto.rating) // Core Data usually uses Int16/32/64
            playlist.coverImageUrlString = dto.coverImageUrlString
            playlist.createdAt = dto.createdAt
            playlist.updatedAt = dto.updatedAt
            
            let songsForPlaylist = dto.songs.compactMap { songId in
                return songLookup[songId]
            }
            
            // Assign relationship
            // This replaces the current relationships with the new list from server
            playlist.songs = NSSet(array: songsForPlaylist)
            
            playlistDict[dto.id] = playlist
        }
    }
}

extension PlayList {
    var songsArray: [Song] {
        let set = songs as? Set<Song> ?? []
        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }
    var durationLengthText: String {
        let totalSeconds = totalLength
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var totalLength: Int {
        songsArray.map { Int($0.lengthInSeconds) }.reduce(0, +)
    }
}
