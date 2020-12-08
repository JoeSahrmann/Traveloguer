//
//  AddTripViewController.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/29/20.
//

import UIKit

class AddTripViewController: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    var trip: Trip?
    let ImageVC = UIImagePickerController()
    var index = 0
    
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var locationTitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        locationImg.layer.cornerRadius = 12
        if let tripz = trip {
            locationTitle.text = tripz.name
            let arr = Trip.shareInstance.fetchImage()
            locationImg.image = UIImage(data: arr[index].coverPhoto!)
        }else{
            return
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func AddPhoto(_ sender: Any) {
        openPhotoLibrary()
    }
    
    @IBAction func changeTitle(_ sender: Any) {
        title = locationTitle.text
    }
    
    
   
    @IBAction func Save(_ sender: Any) {
    if( locationImg.image == nil || locationTitle.text == nil ){
            action(message: "You need to select ALL fields including a reciept to verify your entry")
        }else{
        let name = locationTitle.text
        let img = locationImg.image
       
        var tripp: Trip?
        if let existingEntry = tripp{
            existingEntry.name = name
    
            if case existingEntry.coverPhoto = img?.pngData() {
                Trip.shareInstance.saveImage(data: existingEntry.coverPhoto!)
            }
            //existingEntry.img = imageData
            
            tripp = existingEntry
        }else {
            tripp = Trip(name: name, coverPhoto: img?.pngData())
        }
        
        if let t = trip {
            do {
               // MainViewController.btotaler(ledgen?.amount ?? 0.0)
                let managedText = t.managedObjectContext
                try managedText?.save()
                self.navigationController?.popViewController(animated: true)
            }catch {
                action(message: "Trip could not be saved")
            }
        }
    
        }
        self.navigationController?.popViewController(animated: true)
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
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//
//        guard let image = info[.editedImage] as? UIImage else {
//            action(message: "No image found")
//            print("No image found")
//            return
//        }
//        // print out the image size as a test
//        locationImg.image = image
//        //print(image.size)
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        locationImg.image = userPickedImage

        picker.dismiss(animated: true)
    }
    //this is to handle if the camera function is cancled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           defer {
               picker.dismiss(animated: true)
           }

           print("did cancel")
       }


}
