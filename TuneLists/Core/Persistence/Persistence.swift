//
//  Persistence.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import CoreData

struct PersistenceController {
    @MainActor
    static let preview: PersistenceController = getPreview()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TuneLists")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveContextIfNeeded() throws {
        guard container.viewContext.hasChanges else {
            // For efficiency, exit immediately if there are no changes.
            return
        }
        
        var saveError: Error?
        // Important for thread safety
        container.viewContext.performAndWait {
            do {
                try container.viewContext.save()
            } catch {
                saveError = error
            }
        }

        // Re-throw any captured error
        if let error = saveError {
            print("❌ Error saving Core Data context: \(error.localizedDescription)")
            throw error
        }
    }
    
    func insert(jsonData: Data) async throws {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let payload = try decoder.decode(RootJSON.self, from: jsonData)
        
        
        await container.performBackgroundTask { context in
            // Setting merge policies as this is a child context so it does not inherit them.
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            context.automaticallyMergesChangesFromParent = true
            do {
                print("🔄 Starting Import...")
                
                // STEP A: Import Artists (This implicitly creates/updates Songs)
                // We don't need the result here, just the side effects
                try Artist.importData(from: payload.artists, in: context)
                print("✅ Imported \(payload.artists.count) artists and their songs.")
                
                // STEP B: Import Playlists (Links to the songs created in Step A)
                try PlayList.importData(from: payload.playlists, in: context)
                print("✅ Imported \(payload.playlists.count) playlists.")
                
                
                if context.hasChanges {
                    try context.save()
                    print("💾 Saved to Database.")
                }
            } catch {
                print("❌ Import Failed: \(error)")
            }
        }
    }
    
    func deletePlaylist(_ playlist: PlayList) async throws {
        container.viewContext.delete(playlist)
        try container.viewContext.save()
    }
}
// MARK: - Preview Setup
extension PersistenceController {
    private static func getPreview() -> PersistenceController {
        let result = PersistenceController(inMemory: true)
        let context = result.container.viewContext
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let jsonData = try Data(contentsOf: Bundle.main.url(forResource: "demo_data", withExtension: "json")!)
            let payload = try decoder.decode(RootJSON.self, from: jsonData)
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            try Artist.importData(from: payload.artists, in: context)
            try PlayList.importData(from: payload.playlists, in: context)
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }
}
