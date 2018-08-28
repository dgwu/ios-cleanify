//
//  ReportDetailViewController.swift
//  Cleanify
//
//  Created by Andre Tirta Wijaya on 27/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportDetailViewController: UIViewController {

    @IBOutlet weak var reportDetailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var submittedDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var reportDetailTitle:String? = nil
    var reportDetailDescription:String? = nil
    var reportDetailPhotoUrl:String? = nil
    var reportDetailLocationDescription:String? = nil
    var reportDetailLocationLat:Double? = nil
    var reportDetailLocationLong:Double? = nil
    var reportDetailSubmittedDate:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let reportDetailTitle = reportDetailTitle{
            titleLabel.text=reportDetailTitle
        }
        
        if let reportDetailDescription = reportDetailDescription{
            descriptionLabel.text = reportDetailDescription
        }
        
        if let reportDetailPhotoUrl = reportDetailPhotoUrl{
            GeneralHelper.fetchImage(from: reportDetailPhotoUrl) { (fetchedImage) in
                if let fetchedImage = fetchedImage{
                    DispatchQueue.main.async{
                        self.reportDetailImage.image = fetchedImage
                    }
                }
            }
        }
        
        if let reportDetailLocationDescription = reportDetailLocationDescription{
            locationButton.setTitle(reportDetailLocationDescription, for: .normal)
        }
        
        if let reportDetailSubmittedDate = reportDetailSubmittedDate{
            submittedDateLabel.text = "Submitted on: " + reportDetailSubmittedDate
        }
        
        descriptionLabel.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
