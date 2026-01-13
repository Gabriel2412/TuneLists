//
//  TuneListError.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//
import Foundation


struct TuneListError: Error, Identifiable, Equatable {
    let id: String = UUID().uuidString
    let localizedDescription: String
    let iconName: String
    
    static var deleteItemFailed: TuneListError {
        return TuneListError(localizedDescription: "Failed to delete item", iconName: "trash.slash.fill")
    }
    static var syncFailed: TuneListError {
        return TuneListError(localizedDescription: "Failed to sync with server", iconName: "wifi.slash")
    }
    
    static var newPlaylistFailed: TuneListError {
        return TuneListError(localizedDescription: "Failed to create new playlist", iconName: "pencil.slash")
    }
    
    static func == (lhs: TuneListError, rhs: TuneListError) -> Bool {
        return lhs.id == rhs.id
    }
}
