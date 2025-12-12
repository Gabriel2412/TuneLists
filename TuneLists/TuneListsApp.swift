//
//  TuneListsApp.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI
import CoreData

@main
struct TuneListsApp: App {
    
    private let persistenceController: PersistenceController
    
    @State private var tuneListService: TuneListService
    @State private var errorService: ErrorService = ErrorService()
    
    init() {
        persistenceController = PersistenceController()
        _tuneListService = .init(wrappedValue: TuneListService(persistenceController: persistenceController,
                                                               networkLayer: NetworkMockedLayer()))
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(tuneListService)
                .environment(errorService)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
