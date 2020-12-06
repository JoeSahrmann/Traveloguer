//
//  StopTableViewCell.swift
//  Travelogue
//
//  Created by Joe Sahrmann on 11/18/20.
//

import UIKit

class StopTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var stopPic: UIImageView!
    @IBOutlet weak var stopTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

