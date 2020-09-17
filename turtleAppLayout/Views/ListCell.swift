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

    override func awakeFromNib() {
        super.awakeFromNib()

        cellView.layer.cornerRadius = cellView.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
