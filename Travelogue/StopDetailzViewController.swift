//
//  StopDetailzViewController.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//

import UIKit
import CoreData

class StopDetailzViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    var trip: Trip?
    var stop: Stop?
    var index = 0
    var tripz = [Trip]()
    var tripName = ""
    let ImageVC = UIImagePickerController()
   

    
    @IBOutlet weak var tripLocationTF: UITextField!
    @IBOutlet weak var tripPicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tripPicture.layer.cornerRadius = 12
        if let tripzz = trip {
            title = tripName
            tripLocationTF.text = tripzz.name
            let arr = Trip.shareInstance.fetchImage()
            tripPicture.image = UIImage(data: arr[index].coverPhoto!)
            
        } else{
                
            }
            return
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        StopsViewController().fetchTrips(searchString: "")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedText = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        do {
            tripz = try managedText.fetch(fetchRequest)
            
            
        }catch{
            print("fetch failed")
        }
        tripLocationTF.text = tripz[index].name
        title = tripLocationTF.text
    }
    @IBAction func chosePic(_ sender: Any) {
        openPhotoLibrary()
    }
    func openPhotoLibrary() {
           //this is for if the library can't open
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                action(message: "can't open the photo library")
                print("can't open photo library")
                return
            }
        //this sets the up
        ImageVC.sourceType = .photoLibrary
        ImageVC.delegate = self
        ImageVC.allowsEditing = true
        present(ImageVC, animated: true)
        }
    func action(message: String){
        let alert = UIAlertController(title: nil , message: message, preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        tripPicture.image = userPickedImage

        picker.dismiss(animated: true)
    }
    //this is to handle if the camera function is cancled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           defer {
               picker.dismiss(animated: true)
           }

           print("did cancel")
       }


    @IBAction func DeletTrip(_ sender: Any) {

        confirmDeleteTrip(at: index)
        
    }
    func confirmDeleteTrip(at indexPath: Int) {
        let trip = tripz[indexPath]
        
        if let stopSet = trip.stops, stopSet.count > 0 {
            // confirm deletion
            let name = trip.name ?? "Trip?"
            let alert = UIAlertController(title: "Delete Trip", message: "\(name) contains \(stopSet.count) stops. Do you want to delete it?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                (alertAction) -> Void in
                // handle cancellation of deletion
//                self.tripsTV.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {
                (alertAction) -> Void in
                // handle deletion here
                self.deleteTrip(at: indexPath)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let name = trip.name ?? "Trip?"
            let stopSets = trip.stops
            let alert = UIAlertController(title: "Delete Trip", message: "\(name) contains \(stopSets?.count ?? 0) stops. Do you want to delete it?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                (alertAction) -> Void in
                // handle cancellation of deletion
//                self.tripsTV.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {
                (alertAction) -> Void in
                // handle deletion here
                self.deleteTrip(at: indexPath)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    


    
    func deleteTrip(at indexPath: Int) {
        let trip = tripz[indexPath]
        
        if let managedObjectContext = trip.managedObjectContext {
            managedObjectContext.delete(trip)
            
            do {
                try managedObjectContext.save()
                self.tripz.remove(at: indexPath)
                
//                tripsTV.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Delete failed: \(error).")
//                tripsTV.reloadData()
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        updateTrip(at: index, name: tripLocationTF.text ?? tripz[index].name ?? "", img: (tripPicture.image?.pngData())!)
    }
    func updateTrip(at indexPath: Int, name: String, img: Data) {
        let trip = tripz[indexPath]
        trip.name = name
        trip.coverPhoto = img
        
        if let managedObjectContext = trip.managedObjectContext {
            do {
                try managedObjectContext.save()
                StopsViewController().fetchTrips(searchString: "")
            } catch {
                print("Update failed.")
//                tripsTV.reloadData()
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
  
    @IBAction func changeName(_ sender: Any) {
        title = tripLocationTF.text
    }
    func saveStop(title: String?, date: Date?, pic: Data?, cap: String?){
        StopsViewController().fetchTrips(searchString: "")
        guard let stoptitle = title else {
            TripsViewController().alertNotifyUser(message: "Document not saved.\nThe name is not accessible.")
            return
        }

        let stopTitle = stoptitle.trimmingCharacters(in: .whitespaces)
        if (stopTitle == "") {
            TripsViewController().alertNotifyUser(message: "Document not saved.\nA name is required.")
            return
        }
        


        if stop == nil {
            // document doesn't exist, create new one
            if let trip = trip {
                stop = Stop(title: title, date: date, caption: cap, pic: pic, trip: trip)
            }
        } else {
            // document exists, update existing one
            if let trip = trip {
                stop?.update(title: title, date: date, caption: cap, pic: pic, trip: trip)
            }
        }

        if let stop = stop {
            do {
                let managedContext = stop.managedObjectContext
                try managedContext?.save()
            } catch {
                TripsViewController().alertNotifyUser(message: "Document not saved.\nAn error occured saving context.")
            }
        } else {
            TripsViewController().alertNotifyUser(message: "Document not saved.\nA Document entity could not be created.")
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}
