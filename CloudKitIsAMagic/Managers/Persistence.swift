//
//  Persistence.swift
//  CloudKitIsAMagic
//
//  Created by Konstantin Kolosov on 04.06.2024.
//

import Foundation
import CoreData
import SwiftData

protocol Persistence {
    // CoreData ManagedContext
    var cdContext: NSManagedObjectContext { get }

    // SwiftData Managed Container
    var sdContainer: ModelContainer { get }
}

struct PersistenceController: Persistence {
    
    static var shared: Persistence = PersistenceController()

    // Persistence Protocol
    var sdContainer: ModelContainer
    
    var cdContext: NSManagedObjectContext { container.viewContext }

    // Internal
    let container: NSPersistentCloudKitContainer

    // Private
    private init(inMemory: Bool = false) {
        let coreDataDatabaseName = "CoreDataModel"
        container = NSPersistentCloudKitContainer(name: coreDataDatabaseName)
        container.configure(inMemory: inMemory, databaseName: coreDataDatabaseName)

        sdContainer = ModelContainer.getConfiguredSwiftDataContainer(inMemory: inMemory)
    }
}

// MARK: - Private extensions
private extension NSPersistentCloudKitContainer {
    func configure(inMemory: Bool, databaseName: String) {
        self.viewContext.automaticallyMergesChangesFromParent = true
        if inMemory {
            self.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let url = URL.storeURL(for: "group.com.KKolosov.CloudKitIsAMagic", databaseName: databaseName)
            self.persistentStoreDescriptions.first?.url = url
            self.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
        self.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

private extension ModelContainer {
    static func getConfiguredSwiftDataContainer(inMemory: Bool) -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        let swiftDataContainer = try! ModelContainer(
            for: SwiftDataNote.self,
            configurations: config)
        return swiftDataContainer
    }
}

private extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        var containerUrl: URL

        guard let initialContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        #if os(tvOS)
        containerUrl = initialContainer.appendingPathComponent("Library/Caches")
        #else
        containerUrl = initialContainer
        #endif

        return containerUrl.appendingPathComponent("\(databaseName).sqlite")
    }
}

// MARK: - Syntax Sugar
extension ModelContainer {
    static var current: ModelContainer { PersistenceController.shared.sdContainer }
}

extension NSManagedObjectContext {
    static var current: NSManagedObjectContext { PersistenceController.shared.cdContext }
}
