//
//  ExampleDBModel+CoreDataClass.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//
//

import CoreData
import Foundation

@objc(ExampleDBModel)
public class ExampleDBModel: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var value: String
}

extension ExampleDBModel {
    static let entityName: String = "ExampleDBModel"

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExampleDBModel> {
        return NSFetchRequest<ExampleDBModel>(entityName: Self.entityName)
    }
}
