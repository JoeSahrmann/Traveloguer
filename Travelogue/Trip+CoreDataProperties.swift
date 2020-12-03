//
//  Trip+CoreDataProperties.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var name: String?
    @NSManaged public var coverPhoto: Data?
    @NSManaged public var stops: NSSet?

}

// MARK: Generated accessors for stops
extension Trip {

    @objc(addStopsObject:)
    @NSManaged public func addToStops(_ value: Stop)

    @objc(removeStopsObject:)
    @NSManaged public func removeFromStops(_ value: Stop)

    @objc(addStops:)
    @NSManaged public func addToStops(_ values: NSSet)

    @objc(removeStops:)
    @NSManaged public func removeFromStops(_ values: NSSet)

}

extension Trip : Identifiable {

}
