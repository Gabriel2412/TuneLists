//
//  ErrorService.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//


import SwiftUI

@Observable
final class ErrorService {
    
    private(set) var errorQueue: [TuneListError] = []
        
    func showError(_ error: TuneListError, for time: TimeInterval = 3.0) {
        errorQueue.append(error)
        Task {
            try? await Task.sleep(for: .seconds(time))
            
            await MainActor.run {
                errorQueue.removeAll(where: {$0.id == error.id })
            }
        }
    }
}
