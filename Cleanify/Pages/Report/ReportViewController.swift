//
//  ReportViewController.swift
//  Cleanify
//
//  Created by Andre Tirta Wijaya on 20/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var addReportButton: UIButton!
    @IBOutlet weak var reportTableView: UITableView!
    
    var reportData:[CleanifyReport]=[CleanifyReport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportTableView.delegate = self
        reportTableView.dataSource = self
        
        addReportButton.layer.cornerRadius = 22.5
        
        getReportList()
        print("reportData: \(reportData)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getReportList() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let cleanifyApi = CleanifyApi()
        cleanifyApi.fetchReportList { (reports) in
            print("reports: \(reports)")
            if let reports = reports {
                self.reportData = reports
                
                DispatchQueue.main.async {
                    self.reportTableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            }
        }
    }
    
}

extension ReportViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportDetailTableViewCell
        
//        var tempImage:UIImage?=nil
//
//        if let url = URL(string: reportData[indexPath.row].photo_url) {
//            cell.reportDetailImage.contentMode = .scaleAspectFit
//            tempImage = downloadImage(url: url)
//        }
//
//        if let tempImage = tempImage{
//            cell.reportDetailImage.image = tempImage
//        }
        
        cell.reportDetailImage.image = #imageLiteral(resourceName: "Act! Icon")
        cell.reportDetailTitle.text = reportData[indexPath.row].title
        cell.reportDetailDescription.text = reportData[indexPath.row].description
        cell.reportDetailLocation.text = reportData[indexPath.row].location_desc
        cell.reportDetailDateTime.text =  reportData[indexPath.row].created_at
        
//        GeneralHelper.fetchImage(from: event.photoURL) { (fetchedImage) in
//            if let fetchedImage = fetchedImage {
//                DispatchQueue.main.async {
//                    cell.eventImageView.image = fetchedImage
//                }
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ReportDetailSegue", sender: indexPath)
    }
}

