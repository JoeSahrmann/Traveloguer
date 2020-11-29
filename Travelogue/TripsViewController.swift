//
//  TripsViewController.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//
import CoreData
import UIKit

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //the CD
    var tripz = [Trip]()
    //the SB/IB

    @IBOutlet weak var tripsTV: UITableView!
    var threeDots = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.cyan, renderingMode: .alwaysOriginal)
    var deleteImage = UIImage(systemName: "x.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    var editImage = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
    func even(_ number: Int) -> Bool{
        return number % 2 == 0
    }
//    didSet {
//            // Make it card-like
//            cardView.layer.cornerRadius = 10
//            cardView.layer.shadowOpacity = 1
//            cardView.layer.shadowRadius = 2
//            cardView.layer.shadowColor = UIColor(named: "Orange")?.cgColor
//            cardView.layer.shadowOffset = CGSize(width: 3, height: 3)
//            cardView.backgroundColor = UIColor(named: "Red")
//        }
//    }
    
    //the basics
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTV.delegate = self
        tripsTV.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Travel"
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchTrips(searchString: "")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //To add more trips
   
 
    @IBAction func addTrip(_ sender: Any) {
        let alert = UIAlertController(title: "Add Trip", message: "Enter new location!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if let textField = alert.textFields?[0], let name = textField.text {
                let tripTitle = name.trimmingCharacters(in: .whitespaces)
                if (tripTitle == "") {
                    self.alertNotifyUser(message: "Trip not created.\nThe title must contain a value.")
                    return
                }
                self.addTrip(name: tripTitle)
            } else {
                self.alertNotifyUser(message: "Trip not created.\nThe title is not accessible.")
                return
            }
            
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "trip location"
            textField.isSecureTextEntry = false
            
        })
        self.present(alert, animated: true, completion: nil)
    }
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
    func addTrip(name: String) {
        // check if category by that name already exists
        if (tripExists(name: name)) {
            alertNotifyUser(message: "Trip \(name) already exists.")
            return
        }
        
        let trip = Trip(name: name)
        
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
    func editTrip(at indexPath: IndexPath) {
        let trip = tripz[indexPath.row]
        let alert = UIAlertController(title: "Edit Trip", message: "Fix location title.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if let textField = alert.textFields?[0], let name = textField.text {
                let tripTitle = name.trimmingCharacters(in: .whitespaces)
                if (tripTitle == "") {
                    self.alertNotifyUser(message: "Trip title not changed.\nA title is required.")
                    return
                }
                
                if (tripTitle == trip.name) {
                    // Nothing to change, new name is old name.
                    // Do this check before checking that categoryExists,
                    // otherwise if category name doesn't change error about already existing will occur.
                    return
                }
                
                if (self.tripExists(name: tripTitle)) {
                    self.alertNotifyUser(message: "Category name not changed.\n\(tripTitle) already exists.")
                    return
                }
                
                self.updateTrip(at: indexPath, name: tripTitle)
            } else {
                self.alertNotifyUser(message: "Trip title not changed.\nThe title is not accessible.")
                return
            }
            
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "\(trip.name ?? "trip location")"
            textField.isSecureTextEntry = false
            textField.text = trip.name
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
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
//
//
//        DispatchQueue.main.async
//            {
//                cell.favPic.layer.cornerRadius = 10.0;
//                cell.tripTitle.roundCorners([.topRight, .bottomRight], radius: 10)
//            cell.tripTitle.backgroundColor = UIColor.black
//            cell.favPic.backgroundColor = UIColor.red
//            }
        if let cell = cell as? TripsTableViewCell {
            let trip = tripz[indexPath.row]
            cell.tripTitle.text = trip.name
            cell.favPic.layer.cornerRadius = 10.0;
//            cell.tripTitle.cor([.topRight, .bottomRight,.bottomLeft, .bottomRight], radius: 10)
//            cell.tripTitle.backgroundColor = UIColor.black
            cell.tripTitle.UILableTextShadow(color: UIColor.black)
            cell.favPic.backgroundColor = UIColor.red
            cell.tripTitle.layer.masksToBounds = true
            cell.favPic.layer.masksToBounds = true
//            cell.tripTitle.isHidden = true
        }
        //style me please
//        cell.contentView.backgroundColor=mint
//        cell.contentView.tintColor=mintText
       // cell.backgroundView
        return cell
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .normal, title: "Delete/Edit") { (action, view, completion) in
//            //this is where the action sheet controler is created to pop either delet or edit
//            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            //first action is added eddit
//            alert.addAction(UIAlertAction(title: "Edit", style: .default) { (action) in
//               //this should take you to the screen to edit the title
//                self.editTrip(at: indexPath)
//
//
//            })
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
//
//        return UISwipeActionsConfiguration(actions: [action])
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UIContextualAction]? {
//        let delete = UIContextualAction(style: .destructive, title: "Delete") {
//            action, index,<#arg#>  in
//            self.confirmDeleteTrip(at: indexPath)
//        }
//
//        let edit = UIContextualAction(style: .default, title: "Edit") {
//            action, index,<#arg#>  in
//            self.editTrip(at: indexPath)
//        }
//        edit.backgroundColor = UIColor.blue
//
//        return [delete, edit]
//    }

}

