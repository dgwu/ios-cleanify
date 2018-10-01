//
//  TableViewController.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 30/09/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var issueProgress: UIProgressView!
    @IBOutlet weak var eventProgress: UIProgressView!
    @IBOutlet weak var issueRemainingCount: UILabel!
    @IBOutlet weak var eventRemainingCount: UILabel!
    @IBOutlet weak var issueBadge: UIImageView!
    @IBOutlet weak var eventBadge: UIImageView!
    @IBOutlet weak var issueCount: UILabel!
    @IBOutlet weak var eventCount: UILabel!
    
    var eventList:[[String:Any]] = [[:]]
    var upcomingEventList:[[String:Any]] = [[:]]
    var issueList:[[String:Any]] = [[:]]
    var headerTitle:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(getUserToken() != "") {
            loadIssueReported()
            loadEventParticipated()
            loadUpcomingEvents()
        }
    }
    
    func loadIssueReported() {
        doHttpGetWithParam(url: ISSUE_REPORTED_URL, request: ["api_token" : getUserToken()]) { (result) in
            DispatchQueue.main.async {
                if (result["reports"] as? String == "") {
                    self.issueCount.text = "\(0)"
                    self.issueBadge.image = UIImage(named: self.issueBadgeLevel(level: self.getIssueLevel(0)))
                    self.issueList = []
                }
                else {
                    print(result)
                    let data:[[String:Any]] = result["reports"] as! [[String : Any]]
                    self.issueCount.text = "\(data.count)"
                    self.issueBadge.image = UIImage(named: self.issueBadgeLevel(level: self.getIssueLevel(data.count)))
                    self.issueList = data
                }
            }
        }
    }
    
    func loadEventParticipated() {
        doHttpGetWithParam(url: PARTICIPATED_EVENT_URL, request: ["api_token" : getUserToken()]) { (result) in
            DispatchQueue.main.async {
                if (result["events"] as? String == "") {
                    self.eventCount.text = "\(0)"
                    self.eventBadge.image = UIImage(named: self.eventBadgeLevel(level: self.getEventLevel(0)))
                    self.eventList = []
                }
                else {
                    let data:[[String:Any]] = result["events"] as! [[String : Any]]
                    self.eventCount.text = "\(data.count)"
                    self.eventBadge.image = UIImage(named: self.eventBadgeLevel(level: self.getEventLevel(data.count)))
                    self.eventList = data
                }
            }
        }
    }
    
    func loadUpcomingEvents() {
        doHttpGetWithParam(url: UPCOMING_EVENT_URL, request: ["api_token" : getUserToken()]) { (result) in
            DispatchQueue.main.async {
                if (result["events"] as? String == "") {
                    self.upcomingEventList = []
                }
                else {
                    let data:[[String:Any]] = result["events"] as! [[String : Any]]
                    self.upcomingEventList = data
                }
            }
        }
    }
    
    func getIssueLevel(_ numberOfData:Int) -> String {
        switch numberOfData {
        case 0...9:
            issueRemainingCount.text = "\(10-numberOfData)"
            issueProgress.progress = Float(numberOfData)/10.00
            return "0"
        case 10...24:
            issueRemainingCount.text = "\(25-numberOfData)"
            issueProgress.progress = Float(numberOfData)/25.00
            return "1"
        case 25...49:
            issueRemainingCount.text = "\(50-numberOfData)"
            issueProgress.progress = Float(numberOfData)/50.00
            return "2"
        case 50...:
            issueProgress.progress = 1.00
            return "3"
        default:
            return "error"
        }
    }
    
    func getEventLevel(_ numberOfData:Int) -> String {
        switch numberOfData {
        case 0...9:
            eventRemainingCount.text = "\(10-numberOfData)"
            eventProgress.progress = Float(numberOfData)/10.00
            return "0"
        case 10...24:
            eventRemainingCount.text = "\(25-numberOfData)"
            eventProgress.progress = Float(numberOfData)/25.00
            return "1"
        case 25...49:
            eventRemainingCount.text = "\(50-numberOfData)"
            eventProgress.progress = Float(numberOfData)/50.00
            return "2"
        case 50...:
            eventProgress.progress = 1.00
            return "3"
        default:
            return "error"
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    func eventBadgeLevel(level:String) -> String {
        return "EventBadge\(level)"
    }
    
    func issueBadgeLevel(level:String) -> String {
        return "IssueBadge\(level)"
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 1) {
            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "EventListVC") as? EventListViewController
            vc?.events = self.upcomingEventList
            vc?.header = "Upcoming Event/s"
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if (indexPath.row == 2) {
            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "EventListVC") as? EventListViewController
            vc?.events = self.eventList
            vc?.header = "Event/s Participated"
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "IssueListVC") as? IssueListViewController
            vc?.issues = self.issueList
            vc?.header = "Issue/s Reported"
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
}
