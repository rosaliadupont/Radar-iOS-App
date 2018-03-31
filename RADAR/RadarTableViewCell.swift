//
//  RadarTableViewCell.swift
//  RADAR
//
//  Created by Omar Wasim on 7/29/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Foundation

protocol RadarTableViewCellDelegate: class {
    func callSegueFromCell(myData: Int)
}

class RadarTableViewCell: UITableViewCell {
    

    //var restaurant = Restaurant()
    var index: Int = 0
    weak var delegate: RadarTableViewCellDelegate?
    
    static let height: CGFloat = 200
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var checkedPeople: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var placeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func checkinTapped(_ sender: UIButton) {
        print(index)
        delegate?.callSegueFromCell(myData: index)
    }
    
    

}
