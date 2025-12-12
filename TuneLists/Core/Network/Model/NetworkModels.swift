//
//  NetworkModels.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//
import Foundation

/*
 NOTE OF INTEREST:
 
 In order to avoid mapping JSON dictionaries, we will use this small Decodable structs
 To aid the conversion between server JSON objects and CoreData objects.
 As CoreData has the "Container.viewContext" requirement.
 There is a more complex way I did in the past where you can work-around it and Decode CoreData objects.
 I will for time constraints do it this way as its faster and simpler.
 I can explain if interested :)
 */
struct SongJSON: Decodable {
    let id: String
    let name: String
    let lengthInSeconds: Int32
}

struct ArtistJSON: Decodable {
    let id: String
    let name: String
    let songs: [SongJSON]
}

struct PlaylistJSON: Decodable {
    let id: String
    let name: String
    let rating: Int
    let coverImageUrlString: String
    let createdAt: Date
    let updatedAt: Date
    let songs: [String]  // Song IDs
}

struct RootJSON: Decodable {
    let artists: [ArtistJSON]
    let playlists: [PlaylistJSON]
}
