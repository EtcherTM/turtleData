//
//  ListCell.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/7/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var photoImage1: UIImageView!
    @IBOutlet weak var photoImage2: UIImageView!
    @IBOutlet weak var photoImage3: UIImageView!
    @IBOutlet weak var photoImage4: UIImageView!
    @IBOutlet weak var photoImage5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cellView.layer.cornerRadius = cellView.frame.size.height / 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
