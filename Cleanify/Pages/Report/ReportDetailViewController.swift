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
    @IBOutlet weak var statusImage: UIImageView!
    
    var reportDetailTitle:String? = nil
    var reportDetailDescription:String? = nil
    var reportDetailPhotoUrl:String? = nil
    var reportDetailLocationDescription:String? = nil
    var reportDetailLocationLat:Double? = nil
    var reportDetailLocationLong:Double? = nil
    var reportDetailSubmittedDate:String? = nil
    var reportDetailStatus:String? = nil
    
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
            locationButton.setTitle("   \(reportDetailLocationDescription)", for: .normal)
        }
        
        if let reportDetailSubmittedDate = reportDetailSubmittedDate{
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
//            cell.reportDetailDateTime.text = formatter.string(from: formatter.date(from: reportData[indexPath.row].created_at) ?? Date())
            submittedDateLabel.text = "Submitted on " + formatter.string(from: formatter.date(from: reportDetailSubmittedDate) ?? Date())
        }
        
        if let reportDetailStatus = reportDetailStatus{
            switch reportDetailStatus {
            case "NH": // need help
                statusImage.image = #imageLiteral(resourceName: "x icon large")
                break
            case "S": // solved
                statusImage.image = #imageLiteral(resourceName: "check icon large")
                break
            case "OP": // on progress
                statusImage.image = #imageLiteral(resourceName: "! icon large")
                break
            case "FR": // false report
//                statusImage.image = 
                break
            default:
                break
            }
        }
        
        descriptionLabel.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
