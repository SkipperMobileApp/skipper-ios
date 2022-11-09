//
//  Database.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import CoreData

/// A database class, which contains members related to database
class Database {
    // MARK: - Definitions

    enum Constants {
        static let containerName = "Database"
    }

    // MARK: - Properties

    /// Current context of the persistent container
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    /// Persistent container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
        return container
    }()

    // MARK: - Data Methods

    /// Saves changes in database if needed
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
