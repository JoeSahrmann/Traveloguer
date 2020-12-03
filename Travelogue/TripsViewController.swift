//
//  TripsViewController.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//
import CoreData
import UIKit

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    //the CD
    var tripz = [Trip]()
    let ImageVC = UIImagePickerController()
    var tripCover: Trip?
    //the SB/IB
    let coverImage = UIImageView()

   
 
    @IBOutlet weak var tripsTV: UITableView!
    var threeDots = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.cyan, renderingMode: .alwaysOriginal)
    var deleteImage = UIImage(systemName: "x.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    var editImage = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
    func even(_ number: Int) -> Bool{
        return number % 2 == 0
    }
    var refreshControl = UIRefreshControl()
    
    //the basics
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        tripsTV.delegate = self
        tripsTV.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Travel"
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//           tripsTV.addSubview(refreshControl)
        tripsTV.reloadData()
        navigationController?.navigationBar.isTranslucent = true
        
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchTrips(searchString: "")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedText = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        do {
            tripz = try managedText.fetch(fetchRequest)
           
            tripsTV.reloadData()
            
        }catch{
            print("fetch failed")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //To add more trips
//    @objc func refresh(_ sender: AnyObject) {
//        tripsTV.reloadData()
//    }
 
    @IBAction func addTrip(_ sender: Any) {
    }
//        let alert = UIAlertController(title: "Add Trip", message: "Enter new location!", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: { [self]
//            (alertAction) -> Void in
//            if let textField = alert.textFields?[0], let name = textField.text {
//                let tripTitle = name.trimmingCharacters(in: .whitespaces)
//                if (tripTitle == "") {
//                    self.alertNotifyUser(message: "Trip not created.\nThe title must contain a value.")
//                    return
//                }
//
//
////                if case self.tripCover?.coverPhoto = self.coverImage.image?.pngData(){
////                    Trip.shareInstance.saveImage(data: (self.tripCover?.coverPhoto!)!)
////                }
////                self.addTrip(name: tripTitle, img: (self.tripCover?.coverPhoto!)!)
//            } else {
//                self.alertNotifyUser(message: "Trip not created.\nThe title is not accessible.")
//                return
//            }
//
//        }))
//
//        alert.addTextField(configurationHandler: {(textField: UITextField!) in
//            textField.placeholder = "trip location"
//            textField.isSecureTextEntry = false
//
//        })
//        self.present(alert, animated: true, completion: nil)
//    }
    //alert messages
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    func action(_ message: String){
        let alert = UIAlertController(title: nil , message: message, preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
    }
    //start the CRUD for Trips
    func addTrip(name: String, img: Data) {
        // check if category by that name already exists
        if (tripExists(name: name)) {
            alertNotifyUser(message: "Trip \(name) already exists.")
            return
        }
        
        let trip = Trip(name: name, coverPhoto: img)
        
        if let trip = trip {
            do {
                let managedObjectContext = trip.managedObjectContext
                try managedObjectContext?.save()
            } catch {
                action("Trip could not be saved.")
            }
        } else {
            action("Trip could not be created.")
        }
        
        fetchTrips(searchString: "")
    }
    
    func fetchTrips(searchString: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            if (searchString != "") {
                fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", searchString)
            }
            tripz = try managedContext.fetch(fetchRequest)
            tripsTV.reloadData()
        } catch {
            print("Fetch could not be performed")
        }
    }
    
    func tripExists(name: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, name != "" else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        do {
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
   
 
        
//    func editTrip(at indexPath: IndexPath) {
//         func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "addTrip" {
//                if let destination = segue.destination as? AddTripViewController,
//                    let row = tripsTV.indexPathForSelectedRow?.row {
//                    destination.trip = tripz[row]
//                    destination.index = row
//                }
//            }
//        }
//        let trip = tripz[indexPath.row]
//        let alert = UIAlertController(title: "Edit Trip", message: "Fix location title.", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
//            (alertAction) -> Void in
//            if let textField = alert.textFields?[0], let name = textField.text {
//                let tripTitle = name.trimmingCharacters(in: .whitespaces)
//                if (tripTitle == "") {
//                    self.alertNotifyUser(message: "Trip title not changed.\nA title is required.")
//                    return
//                }
//
//                if (tripTitle == trip.name) {
//                    // Nothing to change, new name is old name.
//                    // Do this check before checking that categoryExists,
//                    // otherwise if category name doesn't change error about already existing will occur.
//                    return
//                }
//                 let imgButton = alert.editButtonItem
//                    imgButton.image = UIImage(systemName: "square.and.arrow.up.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
//
//
//                if (self.tripExists(name: tripTitle)) {
//                    self.alertNotifyUser(message: "Category name not changed.\n\(tripTitle) already exists.")
//                    return
//                }
//
//                self.updateTrip(at: indexPath, name: tripTitle)
//            } else {
//                self.alertNotifyUser(message: "Trip title not changed.\nThe title is not accessible.")
//                return
//            }
//
//        }))
//        alert.addTextField(configurationHandler: {(textField: UITextField!) in
//            textField.placeholder = "\(trip.name ?? "trip location")"
//            textField.isSecureTextEntry = false
//            textField.text = trip.name
//
//        })
//        self.present(alert, animated: true, completion: nil)
  
    
    func confirmDeleteTrip(at indexPath: IndexPath) {
        let trip = tripz[indexPath.row]
        
        if let stopSet = trip.stops, stopSet.count > 0 {
            // confirm deletion
            let name = trip.name ?? "Trip?"
            let alert = UIAlertController(title: "Delete Trip", message: "\(name) contains \(stopSet.count) stops. Do you want to delete it?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                (alertAction) -> Void in
                // handle cancellation of deletion
                self.tripsTV.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {
                (alertAction) -> Void in
                // handle deletion here
                self.deleteTrip(at: indexPath)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            deleteTrip(at: indexPath)
        }
    }
    


    
    func deleteTrip(at indexPath: IndexPath) {
        let trip = tripz[indexPath.row]
        
        if let managedObjectContext = trip.managedObjectContext {
            managedObjectContext.delete(trip)
            
            do {
                try managedObjectContext.save()
                self.tripz.remove(at: indexPath.row)
                tripsTV.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Delete failed: \(error).")
                tripsTV.reloadData()
            }
        }
    }
    
    func updateTrip(at indexPath: IndexPath, name: String) {
        let trip = tripz[indexPath.row]
        trip.name = name
        
        if let managedObjectContext = trip.managedObjectContext {
            do {
                try managedObjectContext.save()
                fetchTrips(searchString: "")
            } catch {
                print("Update failed.")
                tripsTV.reloadData()
            }
        }
    }
   
    //table time
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? TripsTableViewCell {
            let trip = tripz[indexPath.row]
            cell.tripTitle.text = trip.name
            cell.favPic.layer.cornerRadius = 10.0;
            cell.tripTitle.UILableTextShadow(color: UIColor.black)
            let arr = Trip.shareInstance.fetchImage()
            cell.favPic.image = UIImage(data: arr[indexPath.row].coverPhoto!)
            cell.tripTitle.layer.masksToBounds = true
            cell.favPic.layer.masksToBounds = true
        }
        //style me please
//        cell.contentView.backgroundColor=mint
//        cell.contentView.tintColor=mintText
       // cell.backgroundView
        return cell
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .normal, title: "Delete/Edit") { (action, view, completion) in
//            action.backgroundColor = UIColor(named: "background")
//
//            //this is where the action sheet controler is created to pop either delet or edit
//            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            //first action is added eddit
//            alert.addAction(UIAlertAction(title: "Edit", style: .default) { (action) in
//               //this should take you to the screen to edit the title
//                self.work(indexPath.row)
//                print(indexPath.row)
////               var joe = self.performSegue(withIdentifier: "addTrip", sender: Any?.self)
////                func prepare(for segue: UIStoryboardSegue, sender: Self) {
////                    if segue.identifier == "addTrip" {
////                        if let destination = segue.destination as? AddTripViewController
////                            {
////                            destination.trip = self.tripz[indexPath.row]
////                            destination.index = indexPath.row
////                        }
////                    }
////                }
//
//
//                })
//            //this adds the delet action
//            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { (action) in
//
//                self.confirmDeleteTrip(at: indexPath)
//            })
//
//            // This sets up the alert to show next to the button
//            alert.popoverPresentationController?.sourceView = view
//            alert.popoverPresentationController?.sourceRect = view.bounds
//
//            self.present(alert, animated: true, completion: nil)
//                    }
//        action.backgroundColor = UIColor.systemBackground
//        //this doesnt show up in lightn mode need to make colorscheeme
//
//        return UISwipeActionsConfiguration(actions: [action])
//    }
//    func work(_ row: Int){
//        func prepare(for segue: UIStoryboardSegue, sender: Self) {
//            if segue.identifier == "addTrip" {
//                if let destination = segue.destination as? AddTripViewController {                    destination.trip = self.tripz[row]
//                    destination.index = row
//                }
//            }
//        }
//    }
func openPhotoLibrary() {
    //this is for if the library can't open
 guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
         action("can't open the photo library")
         print("can't open photo library")
         return
     }
 //this sets the up
 ImageVC.sourceType = .photoLibrary
 ImageVC.delegate = self
 present(ImageVC, animated: true)
 }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            action("No image found")
            print("No image found")
            return
        }
    
        // print out the image size as a test
        coverImage.image = image
        //print(image.size)
    }
    //this is to handle if the camera function is cancled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           defer {
               picker.dismiss(animated: true)
           }

           print("did cancel")
       }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "addTrip" {
//                if let destination = segue.destination as? AddTripViewController,
//                    let row = tripsTV.indexPathForSelectedRow?.row {
//                    destination.trip = tripz[row]
//                    destination.index = row
//                }
//            }
//
//    }
}

