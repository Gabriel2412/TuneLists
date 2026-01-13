//
//  NetworkService.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//
import SwiftUI

@Observable
class TuneListService {
    
    private let persistenceController: PersistenceController
    private let networkLayer: NetworkLayerProtocol
    
    init(persistenceController: PersistenceController, networkLayer: NetworkLayerProtocol) {
        self.persistenceController = persistenceController
        self.networkLayer = networkLayer
    }

    func syncPlayLists() async throws {
        let data = try await networkLayer.fetchPlayLists()
        try await persistenceController.insertServerData(jsonData: data)
    }
    
    func saveNewPlaylist( title: String) async throws {
        let playlist = try await networkLayer.saveNewPlaylist(title: title)
        try await persistenceController.insertPlaylist(jsonData: playlist)
    }
    
    func saveNewPlaylist(_ playlist: PlayList) async throws {
        try await networkLayer.saveNewPlaylist(playlist)
        try persistenceController.saveContextIfNeeded()
    }
    
    func deletePlaylist(_ playlist: PlayList) async throws {
        try await networkLayer.deletePlaylist(playlist)
        try await persistenceController.deletePlaylist(playlist)
    }
}
