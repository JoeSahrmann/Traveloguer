//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//
//


import CoreData
import UIKit

@objc(Trip)
public class Trip: NSManagedObject {
    convenience init?(name: String?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: Trip.entity(), insertInto: managedContext)
        self.name = name
    }
}
