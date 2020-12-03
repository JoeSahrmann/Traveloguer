//
//  TripsTableViewCell.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/29/20.
//

import UIKit

class TripsTableViewCell: UITableViewCell {

    @IBOutlet weak var favPic: UIImageView!
    
    @IBOutlet weak var tripTitle: UILabel!
//    @IBOutlet weak var stopTitle: UILabel!
//    @IBOutlet weak var stopPic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension UILabel {
   func UILableTextShadow(color: UIColor){
      self.textColor = color
      self.layer.masksToBounds = false
      self.layer.shadowOffset = CGSize(width: 1, height: 1)
      self.layer.rasterizationScale = UIScreen.main.scale
      self.layer.shadowRadius = -1.0
      self.layer.shadowOpacity = 1.0
   }
}


