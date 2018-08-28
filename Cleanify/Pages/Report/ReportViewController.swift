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
    }

    override func viewWillAppear(_ animated: Bool) {
        getReportList()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        getReportList()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getReportList() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let cleanifyApi = CleanifyApi()
        cleanifyApi.fetchReportList { (reports) in
            if let reports = reports {
                self.reportData = reports
                DispatchQueue.main.async {
                    self.reportTableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? IndexPath
        else{
            return
        }
        let destinationVC = segue.destination as! ReportDetailViewController
        destinationVC.reportDetailTitle = reportData[sender.row].title
        destinationVC.reportDetailDescription = reportData[sender.row].description
        destinationVC.reportDetailPhotoUrl = reportData[sender.row].photo_url
        destinationVC.reportDetailLocationDescription = reportData[sender.row].location_desc
        destinationVC.reportDetailLocationLat = reportData[sender.row].location_latitude
        destinationVC.reportDetailLocationLong = reportData[sender.row].location_longitude
        destinationVC.reportDetailSubmittedDate = reportData[sender.row].created_at
        
//        destinationVC.reportDetailDescription = "alskdjflaksdjf,akjsd;lkfja;skldfj;alkdsjf;lka ;lakjsdlfkjasd;lkfjasd lkasjdkflj a;lskdjf;laksjdfl;kj ;lsdkjaf;lkdsjf ;laskjdfklajs dfa sdlkjfasdkf a;slkdfjlaksdjf ;alksdjflkajsd fjsl;kdjf;laskdjfasldfjalksdjf  ;laksdjfl;kasdjf ;laksdjf;klasjdfkls ;alskjdflaksjdf ;lkajs;kldjfl;kjasdf ;lkajs;lkdjf;lkasjdflj ;lkjsal;dkjfl;aksdjf alskdjflaksdjf,akjsd;lkfja;skldfj;alkdsjf;lka ;lakjsdlfkjasd;lkfjasd lkasjdkflj a;lskdjf;laksjdfl;kj ;lsdkjaf;lkdsjf ;laskjdfklajs dfa sdlkjfasdkf a;slkdfjlaksdjf ;alksdjflkajsd fjsl;kdjf;laskdjfasldfjalksdjf  ;laksdjfl;kasdjf ;laksdjf;klasjdfkls ;alskjdflaksjdf ;lkajs;kldjfl;kjasdf ;lkajs;lkdjf;lkasjdflj ;lkjsal;dkjfl;aksdjf alskdjflaksdjf,akjsd;lkfja;skldfj;alkdsjf;lka ;lakjsdlfkjasd;lkfjasd lkasjdkflj a;lskdjf;laksjdfl;kj ;lsdkjaf;lkdsjf ;laskjdfklajs dfa sdlkjfasdkf a;slkdfjlaksdjf ;alksdjflkajsd fjsl;kdjf;laskdjfasldfjalksdjf  ;laksdjfl;kasdjf ;laksdjf;klasjdfkls ;alskjdflaksjdf ;lkajs;kldjfl;kjasdf ;lkajs;lkdjf;lkasjdflj ;lkjsal;dkjfl;aksdjf alskdjflaksdjf,akjsd;lkfja;skldfj;alkdsjf;lka ;lakjsdlfkjasd;lkfjasd lkasjdkflj a;lskdjf;laksjdfl;kj ;lsdkjaf;lkdsjf ;laskjdfklajs dfa sdlkjfasdkf a;slkdfjlaksdjf ;alksdjflkajsd fjsl;kdjf;laskdjfasldfjalksdjf  ;laksdjfl;kasdjf ;laksdjf;klasjdfkls ;alskjdflaksjdf ;lkajs;kldjfl;kjasdf ;lkajs;lkdjf;lkasjdflj ;lkjsal;dkjfl;aksdjf "
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
}

