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
    static let shareInstance = Trip()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImage(data: Data) {
        let imageInstance = Trip(context: context)
        imageInstance.coverPhoto = data
            
        do {
            try context.save()
            print("Image is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage() -> [Trip] {
        var fetchingImage = [Trip]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        
        do {
            fetchingImage = try context.fetch(fetchRequest) as! [Trip]
        } catch {
            print("Error while fetching the image")
        }
        
        return fetchingImage
    }
    convenience init?(name: String?, coverPhoto: Data?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: Trip.entity(), insertInto: managedContext)
        self.name = name
        self.coverPhoto = coverPhoto
    }
}
