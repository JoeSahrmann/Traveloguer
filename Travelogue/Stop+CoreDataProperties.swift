//
//  Stop+CoreDataProperties.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//
//

import Foundation
import CoreData


extension Stop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stop> {
        return NSFetchRequest<Stop>(entityName: "Stop")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var caption: String?
    @NSManaged public var trip: Trip?

}

extension Stop : Identifiable {

}
