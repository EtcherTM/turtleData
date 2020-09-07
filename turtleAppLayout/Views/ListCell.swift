//
//  ListCell.swift
//  turtleAppLayout
//
//  Created by Olivia James on 9/7/20.
//  Copyright © 2020 Sebastien James. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
