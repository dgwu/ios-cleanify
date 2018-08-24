//
//  NewsTableViewCell.swift
//  Cleanify
//
//  Created by Kevin Wijaya on 24/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var NewsImage: UIImageView!
    @IBOutlet weak var NewsTitle: UILabel!
    @IBOutlet weak var NewsDesc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
