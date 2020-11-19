//
//  Stop+CoreDataClass.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//
//

import UIKit
import CoreData

@objc(Stop)
public class Stop: NSManagedObject {
    

    
    convenience init?(title: String?, date: Date?, caption: String?, trip: Trip) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let title = title, title != "" else {
                return nil
        }
        self.init(entity: Stop.entity(), insertInto: managedContext)
        self.title = title
        self.caption = caption
        self.date = Date()//make this a date picker
        
        //self.modifiedDate = Date(timeIntervalSinceNow: 0)
        self.trip = trip
    }
    
    func update(title: String, caption: String?, trip: Trip) {
        self.title = title
        self.caption = caption
       
        //put date picker in here later
       // self.modifiedDate = Date(timeIntervalSinceNow: 0)
        self.trip = trip
    }
}
