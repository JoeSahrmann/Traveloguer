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
    static let shareInstance = Stop()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImage(data: Data) {
        let imageInstance = Stop(context: context)
        imageInstance.pic = data
            
        do {
            try context.save()
            print("Image is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage() -> [Stop] {
        var fetchingImage = [Stop]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stop")
        
        do {
            fetchingImage = try context.fetch(fetchRequest) as! [Stop]
        } catch {
            print("Error while fetching the image")
        }
        
        return fetchingImage
    }

    
    convenience init?(title: String?, date: Date?, caption: String?, pic: Data?, trip: Trip) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let title = title, title != "" else {
                return nil
        }
        self.init(entity: Stop.entity(), insertInto: managedContext)
        self.title = title
        self.caption = caption
        self.date = Date()//make this a date picker
        self.pic = pic
        //self.modifiedDate = Date(timeIntervalSinceNow: 0)
        self.trip = trip
    }
    
    func update(title: String, caption: String?, pic: Data?, trip: Trip) {
        self.title = title
        self.caption = caption
        self.pic = pic
        //put date picker in here later
       // self.modifiedDate = Date(timeIntervalSinceNow: 0)
        self.trip = trip
    }
}
