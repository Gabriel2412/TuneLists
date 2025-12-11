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
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
