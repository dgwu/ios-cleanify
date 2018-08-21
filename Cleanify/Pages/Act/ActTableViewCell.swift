//
//  ActTableViewCell.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 21/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ActTableViewCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
