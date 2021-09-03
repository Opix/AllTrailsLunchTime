// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Restaurant.swift instead.

import Foundation
import CoreData

public enum RestaurantAttributes: String {
    case id = "id"
}

open class _Restaurant: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Restaurant"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Restaurant.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var id: String
    // MARK: - Relationships

}

