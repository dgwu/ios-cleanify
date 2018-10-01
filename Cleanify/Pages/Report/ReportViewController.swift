//
//  ReportViewController.swift
//  Cleanify
//
//  Created by Andre Tirta Wijaya on 20/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
//    @IBOutlet weak var addReportButton: UIButton!
    @IBOutlet weak var reportTableView: UITableView!
    
    var reportData:[CleanifyReport]=[CleanifyReport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportTableView.delegate = self
        reportTableView.dataSource = self
        
//        addReportButton.layer.cornerRadius = 22.5
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        getReportList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getReportList()
    }
    
    @IBAction func refresh(_ sender: Any) {
        getReportList()
    }
    
    func getReportList() {
        print("getReportList mashook")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let cleanifyApi = CleanifyApi()
        cleanifyApi.fetchReportList { (reports) in
            DispatchQueue.main.async {
                if let reports = reports {
                    print(reports)
                    self.reportData = reports
                    self.reportTableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? IndexPath else { return }
        if segue.identifier == "ReportDetailSegue" {
            let destinationVC = segue.destination as! ReportDetailViewController
            
            destinationVC.reportDetailTitle = reportData[sender.row].title
            destinationVC.reportDetailDescription = reportData[sender.row].body
            destinationVC.reportDetailPhotoUrl = reportData[sender.row].photo_url
            destinationVC.reportDetailLocationDescription = reportData[sender.row].location_desc
            destinationVC.reportDetailLocationLat = reportData[sender.row].location_latitude
            destinationVC.reportDetailLocationLong = reportData[sender.row].location_longitude
            destinationVC.reportDetailSubmittedDate = reportData[sender.row].created_at
            destinationVC.reportDetailStatus = reportData[sender.row].status
        }
    }
}

extension ReportViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportDetailTableViewCell
        let event = self.reportData[indexPath.row]
        
        cell.reportDetailTitle.text = reportData[indexPath.row].title
//        cell.reportDetailDescription.text = reportData[indexPath.row].description
        cell.reportDetailLocation.text = reportData[indexPath.row].location_desc
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let formatFromString = DateFormatter()
        formatFromString.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let tempDate = formatFromString.date(from: reportData[indexPath.row].created_at)
                
        cell.reportDetailDateTime.text = formatter.string(from: tempDate ?? Date())
        switch reportData[indexPath.row].status {
        case "NH": // need help
            cell.detailStatusImage.image = #imageLiteral(resourceName: "x icon large")
            break
        case "S": // solved
            cell.detailStatusImage.image = #imageLiteral(resourceName: "check icon large")
            break
        case "OP": // on progress
            cell.detailStatusImage.image = #imageLiteral(resourceName: "! icon large")
            break
        case "FR": // false report
//            cell.detailStatusImage.image =
            break
        default:
            break
        }
        
        GeneralHelper.fetchImage(from: event.photo_url) { (fetchedImage) in
            if let fetchedImage = fetchedImage {
                DispatchQueue.main.async {
                    cell.reportDetailImage.image = fetchedImage
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ReportDetailSegue", sender: indexPath)
    }
}

