//
//  AddStopsViewController.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/29/20.
//

import UIKit
import CoreData
class AddStopsViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var stoptitleTF: UITextField!
    @IBOutlet weak var stopDatePicker: UIDatePicker!
    @IBOutlet weak var stopImageView: UIImageView!
    @IBOutlet weak var stopCaption: UITextView!
    var stop: Stop?
    var trip: Trip?
    var stopz = [Stop]()
    var index = 0
    var stopIndex = 0
    let ImageVC = UIImagePickerController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipe = UISwipeGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(swipe)
        stopImageView.layer.cornerRadius = 12
        stopCaption.layer.cornerRadius = 12
        if let stop = stop {
            let name = stop.title
            stoptitleTF.text = name
            stopCaption.text = stop.caption
            let arr = Stop.shareInstance.fetchImage()
            stopImageView.image = UIImage(data: arr[index].pic!)
            if let stopDate = stop.date{
                stopDatePicker.date = stopDate
            }else{
                print("could not get date")
            }
          
            title = name
        }

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        StopsViewController().fetchStops(searchString: "")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedText = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Stop> = Stop.fetchRequest()
        do {
            stopz = try managedText.fetch(fetchRequest)
            
            
        }catch{
            print("fetch failed")
        }
//        stoptitleTF.text = stopz[index].title
        title = stoptitleTF.text
       
        
    }
  
    
    @IBAction func addPhoto(_ sender: Any) {
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
        stopImageView.image = userPickedImage

        picker.dismiss(animated: true)
    }
    //this is to handle if the camera function is cancled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           defer {
               picker.dismiss(animated: true)
           }

           print("did cancel")
       }

    @IBAction func saveStop(_ sender: Any) {
        guard let name = stoptitleTF.text else {
            TripsViewController().alertNotifyUser(message: "Stop not saved.\nThe name is not accessible.")
            return
        }
        
        let stopTitle = name.trimmingCharacters(in: .whitespaces)
        if (stopTitle == "") {
            TripsViewController().alertNotifyUser(message: "Stop not saved.\nA name is required.")
            return
        }
        let stopCap = stopCaption.text ?? ""
        let stopImg = stopImageView.image?.pngData()
        let stopDate = stopDatePicker.date
        
        if stop == nil {
            // stop doesn't exist, create new one
            if let trip = trip, let stopImage = stopImg{
                stop = Stop(title: stopTitle, date: stopDate, caption: stopCap, pic: stopImage, trip: trip)
            }
        } else {
            // stop exists, update existing one
            if let trip = trip, let stopImage = stopImg {
                stop?.update(title: stopTitle, date: stopDate, caption: stopCap, pic: stopImage, trip: trip)

            }
        }
        if let stop = stop {
            do {
                let managedContext = stop.managedObjectContext
                try managedContext?.save()
            } catch {
                TripsViewController().alertNotifyUser(message: "Stop not saved.\nAn error occured saving context.")
            }
        } else {
            TripsViewController().alertNotifyUser(message: "Stop not saved.\nA Stop entity could not be created.")
        }
        
        navigationController?.popViewController(animated: true)
        
        
    }
    func updateStop(at indexPath: Int, title: String,date: Date, caption: String, img: Data, trip: Trip) {
        let stopCap = stopCaption.text ?? ""
        let stopImg = stopImageView.image?.pngData()
        let stopDate = stopDatePicker.date
        let stopTitle = stoptitleTF.text ?? ""
        let stop = stopz[indexPath]
        stop.title = stopTitle
        stop.caption = stopCap
        stop.date = stopDate
        stop.pic = stopImg
        
        if let managedObjectContext = stop.managedObjectContext {
            do {
                try managedObjectContext.save()
                StopsViewController().fetchStops(searchString: "")
            } catch {
                print("Update failed.")
//                tripsTV.reloadData()
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    func stopSaver(){
        //get title and trim white spaces
        TripsViewController().alertNotifyUser(message: "help")
        guard let name = stoptitleTF.text else {
            TripsViewController().alertNotifyUser(message: "Stop not saved.\nThe name is not accessible.")
            return
        }
        
        let stopTitle = name.trimmingCharacters(in: .whitespaces)
        if (stopTitle == "") {
            TripsViewController().alertNotifyUser(message: "Stop not saved.\nA name is required.")
            return
        }
        let stopCap = stopCaption.text ?? ""
        let stopImg = stopImageView.image?.pngData()
        let stopDate = stopDatePicker.date
        
        if stop == nil {
            // stop doesn't exist, create new one
            if let trip = trip, let stopImage = stopImg{
                stop = Stop(title: stopTitle, date: stopDate, caption: stopCap, pic: stopImage, trip: trip)
            }
        } else {
            // stop exists, update existing one
            if let trip = trip, let stopImage = stopImg {
                stop?.update(title: stopTitle, date: stopDate, caption: stopCap, pic: stopImage, trip: trip)

            }
        }
        if let stop = stop {
            do {
                let managedContext = stop.managedObjectContext
                try managedContext?.save()
            } catch {
                TripsViewController().alertNotifyUser(message: "Stop not saved.\nAn error occured saving context.")
            }
        } else {
            TripsViewController().alertNotifyUser(message: "Stop not saved.\nA Stop entity could not be created.")
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    

}
