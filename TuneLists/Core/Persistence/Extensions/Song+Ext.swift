//
//  Song+Ext.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import CoreData
import Foundation

extension Song {

    @discardableResult
    static func importData(from dtos: [SongJSON], in context: NSManagedObjectContext) throws -> [String: Song] {
        guard !dtos.isEmpty else { return [:] }
        
        // Uniqueness check
        let ids = dtos.map { $0.id }
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids)
        let existingSongs = try context.fetch(request)
        
        var songDict = Dictionary(uniqueKeysWithValues: existingSongs.map { ($0.id!, $0) })
        
        for dto in dtos {
            let song = songDict[dto.id] ?? Song(context: context)
            song.id = dto.id
            song.name = dto.name
            song.lengthInSeconds = dto.lengthInSeconds
            
            // Update Dictionary (needed if we created a new one)
            songDict[dto.id] = song
        }
        
        return songDict
    }
    
    var durationLengthText: String {
        let duration = lengthInSeconds
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

}
