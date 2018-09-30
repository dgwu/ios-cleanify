//
//  EventListViewController.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 30/09/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerCountLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    var events:[[String:Any]] = []
    var header:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("events : \(events)")
        headerLabel.text = header
        headerCountLabel.text = "\(events.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailCell", for: indexPath) as! EventListTableViewCell
        let eventData = events[indexPath.row] as? [String:Any]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        cell.titleLabel.text = eventData?["title"] as! String
        cell.locationLabel.text = eventData?["location_desc"] as! String
        cell.locationLabel.text = eventData?["location_desc"] as! String
        if let date = dateFormatterGet.date(from: eventData?["held_at"] as! String){
            cell.dateLabel.text = dateFormatterPrint.string(from: date)
        } else {
            cell.dateLabel.text = "-"
        }
        
        GeneralHelper.fetchImage(from: eventData!["photo_url"] as! String) { (fetchedImage) in
            if let fetchedImage = fetchedImage {
                DispatchQueue.main.async {
                    cell.eventImage.image = fetchedImage
                }
            }
        }
        cell.isSelected = false
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if menuArr[indexPath.row] == "Logout" {
//            setUserToken(userToken: "")
//            //self.dummyView.isHidden = true
//            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
//    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
