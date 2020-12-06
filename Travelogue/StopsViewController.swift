//
//  StopsViewController.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//

import UIKit

class StopsViewController: UIViewController {


    var trip: Trip?
    var stopz = [Stop]()
    var index = 0
    @IBOutlet weak var stopTV: UITableView!

    
    @IBOutlet weak var tripPic: UIImageView!
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tripPic.layer.cornerRadius = 12
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
        // Do any additional setup after loading the view.
    }
   
    @IBAction func addStop(_ sender: Any) {
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
            cell.stopTitle.layer.masksToBounds = true
            cell.stopPic.layer.masksToBounds = true
        }
        //style me please
//        cell.contentView.backgroundColor=mint
//        cell.contentView.tintColor=mintText
       // cell.backgroundView
        return cell
    }

}
