//
//  ReportDetailTableViewCell.swift
//  Cleanify
//
//  Created by Andre Tirta Wijaya on 23/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var reportDetailImage: UIImageView!
    @IBOutlet weak var reportDetailTitle: UILabel!
    @IBOutlet weak var reportDetailDescription: UILabel!
    @IBOutlet weak var reportDetailDateTime: UILabel!
    @IBOutlet weak var reportDetailLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)	

        // Configure the view for the selected state
    }

}
