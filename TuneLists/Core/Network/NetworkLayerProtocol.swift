//
//  NetworkLayerProtocol.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import Foundation

@MainActor
protocol NetworkLayerProtocol {
    func fetchPlayLists()  async throws -> Data
    func saveNewPlaylist(_ playlist: PlayList) async throws
    func deletePlaylist(_ playlist: PlayList) async throws
}
