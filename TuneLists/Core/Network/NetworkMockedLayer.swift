//
//  NetworkMockedLayer.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import Foundation

class NetworkMockedLayer: NetworkLayerProtocol {
    
    func deletePlaylist(_ playlist: PlayList) async throws {
        print("Pretending we delete the playlist on server....")
    }
    
    func saveNewPlaylist(_ playlist: PlayList) async throws {
        print("Pretending we send data to server...")
    }
    
    func fetchPlayLists() async throws -> Data {
        // Can add a delay to simulate "network time"
        // try await Task.sleep(for: .seconds(2))
        return try Data(contentsOf: Bundle.main.url(forResource: "demo_data", withExtension: "json")!)
    }
    
    func saveNewPlaylist(title: String) async throws -> Data {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        let isoString = formatter.string(from: now)
        
        let jsonDictionary: [[String : Any]] = [[
            "id": UUID().uuidString,
            "coverImageUrlString": "",
            "name": title,
            "rating": 0,
            "createdAt": isoString,
            "updatedAt": isoString,
            "songs" : []
            
        ]]
        return try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
    }
    
}
