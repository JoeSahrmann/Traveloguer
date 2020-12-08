//
//  StopsViewController.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//

import UIKit
import CoreData

class StopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tripz = [Trip]()
    var trip: Trip?
    var stop: Stop?
    var stopz = [Stop]()
    var index = 0
    let dateFormatter = DateFormatter()
    @IBOutlet weak var stopTV: UITableView!

    
    @IBOutlet weak var tripPic: UIImageView!
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopTV.delegate = self
        stopTV.dataSource = self
        tripPic.layer.cornerRadius = -12
        if let tripz = trip {
            title = tripz.name
            let arr = Trip.shareInstance.fetchImage()
//            contentView.backgroundColor = UIColor(patternImage: UIImage(data: arr[index].coverPhoto!)!)
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = (UIImage())
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.view.backgroundColor = .clear
            tripPic.image = UIImage(data: arr[index].coverPhoto!)
        }else{
            return
        }
        stopTV.reloadData()
//        print(tripz[0])

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchTrips(searchString: "")
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
//            return
//        }
//        let managedText = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
//        do {
//            tripz = try managedText.fetch(fetchRequest)
//
//
//        }catch{
//            print("fetch failed")
//        }
        stopTV.reloadData()
        updateStopsArray()
        
    }
    func updateStopsArray() {
        stopz = trip?.stops?.sortedArray(using: [NSSortDescriptor(key: "title", ascending: true)]) as? [Stop] ?? [Stop]()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        } catch {
            print("Fetch could not be performed")
        }
        
    }
    func fetchStops(searchString: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestStop: NSFetchRequest<Stop> = Stop.fetchRequest()
        fetchRequestStop.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            if (searchString != "") {
                fetchRequestStop.predicate = NSPredicate(format: "title contains[c] %@", searchString)
            }
            stopz = try managedContext.fetch(fetchRequestStop)
        } catch {
            print("Fetch could not be performed")
        }
    }
   
   
    @IBAction func addStop(_ sender: Any) {
    }
    func saveStop(title: String?, date: Date?, pic: Data?, cap: String?){
        fetchTrips(searchString: "")
        guard let stoptitle = title else {
//            TripsViewController().alertNotifyUser(message: "Document not saved.\nThe name is not accessible.")
            return
        }

        let stopTitle = stoptitle.trimmingCharacters(in: .whitespaces)
        if (stopTitle == "") {
//            TripsViewController().alertNotifyUser(message: "Document not saved.\nA name is required.")
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
//                TripsViewController().alertNotifyUser(message: "Document not saved.\nAn error occured saving context.")
            }
        } else {
//            TripsViewController().alertNotifyUser(message: "Document not saved.\nA Document entity could not be created.")
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func editTrip(_ sender: Any) {
    }
    
    //table time
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stopCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? StopTableViewCell {
            let stop = stopz[indexPath.row] 
            cell.stopTitle.text = stop.title
            cell.stopPic.layer.cornerRadius = 10.0;
            cell.stopTitle.UILableTextShadow(color: UIColor.black)
            let arr = Trip.shareInstance.fetchImage()
            cell.stopPic.image = UIImage(data: arr[indexPath.row].coverPhoto!)
            if let modifiedDate = stop.date {
                cell.date.text = dateFormatter.string(from: modifiedDate)
            } else {
                cell.date.text = "unknown"
            }
            cell.stopTitle.layer.masksToBounds = true
            cell.stopPic.layer.masksToBounds = true
        }
        //style me please
//        cell.contentView.backgroundColor=mint
//        cell.contentView.tintColor=mintText
       // cell.backgroundView
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "tripCRUD" {
                    if let destination = segue.destination as? StopDetailzViewController{
                        destination.trip = tripz[index]
                        destination.tripName = tripz[index].name ?? ""
                        destination.index = index
                    }
                    if segue.identifier == "stop"{
                        if let destination = segue.destination as? AddStopsViewController{
//                            destination.trip = trip
                            destination.index = index
                    }
                    
                    }
                    
                }

        
        
        
        //            if segue.identifier == "stopCRUD" {
//                if let destination = segue.destination as? StopsViewController,
//                    let row = tripsTV.indexPathForSelectedRow?.row {
//                    destination.trip = tripz[row]
//                    destination.index = row
//                }
//            }

    }

}
