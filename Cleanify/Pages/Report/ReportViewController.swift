//
//  ReportViewController.swift
//  Cleanify
//
//  Created by Andre Tirta Wijaya on 20/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController,  AddReportViewControllerDelegate {
    
    
    @IBOutlet weak var addReportButton: UIButton!
    @IBOutlet weak var reportTableView: UITableView!
    
    
    var reportData:[CleanifyReport]=[CleanifyReport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportTableView.delegate = self
        reportTableView.dataSource = self
        
        addReportButton.layer.cornerRadius = 22.5
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        getReportList()
    }
    
    @IBAction func refreshList(_ sender: Any) {
        getReportList()
    }
    
    
    
        override func viewWillAppear(_ animated: Bool) {
            print("will")
    //        getReportList()
        }
    
    override func viewDidAppear(_ animated: Bool) {
                print("did")
                getReportList()
    }
    
    func getReportList() {
        print("getReportList mashook")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let cleanifyApi = CleanifyApi()
        cleanifyApi.fetchReportList { (reports) in
//            sleep(1)
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
        
        if let addReportVC = segue.destination as? AddReportViewController {
            addReportVC.delegate = self
            print("set delegate")
        }
        
        
        guard let sender = sender as? IndexPath
            else{
                return
        }
        
        if (segue.identifier == "ToAddReport") {
            let addReportVC = segue.destination as! AddReportViewController
            addReportVC.delegate = self
            print("set delegate")
        } else {
            let destinationVC = segue.destination as! ReportDetailViewController
            
            destinationVC.reportDetailTitle = reportData[sender.row].title
            destinationVC.reportDetailDescription = reportData[sender.row].description
            destinationVC.reportDetailPhotoUrl = reportData[sender.row].photo_url
            destinationVC.reportDetailLocationDescription = reportData[sender.row].location_desc
            destinationVC.reportDetailLocationLat = reportData[sender.row].location_latitude
            destinationVC.reportDetailLocationLong = reportData[sender.row].location_longitude
            destinationVC.reportDetailSubmittedDate = reportData[sender.row].created_at
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
        cell.reportDetailDescription.text = reportData[indexPath.row].description
        cell.reportDetailLocation.text = reportData[indexPath.row].location_desc
        cell.reportDetailDateTime.text =  reportData[indexPath.row].created_at
        
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
    
    func represhData() {
        print("represhing")
//        self.getReportList()
    }
    
}

