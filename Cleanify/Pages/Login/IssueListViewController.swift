//
//  IssueListViewController.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 01/10/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class IssueListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerCountLabel: UILabel!
    
    var issues:[[String:Any]] = []
    var header:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        headerLabel.text = header
        headerCountLabel.text = "\(issues.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueDetailCell", for: indexPath) as! IssueListTableViewCell
        let issueData = issues[indexPath.row] as? [String:Any]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        cell.titleLabel.text = issueData?["title"] as! String
        cell.locationLabel.text = issueData?["location_desc"] as! String
        cell.locationLabel.text = issueData?["location_desc"] as! String
        if let date = dateFormatterGet.date(from: issueData?["created_at"] as! String){
            cell.dateLabel.text = dateFormatterPrint.string(from: date)
        } else {
            cell.dateLabel.text = "-"
        }
        
        cell.statusImage.image = UIImage(named: issueData?["status"] as! String)
        
        GeneralHelper.fetchImage(from: issueData!["photo_url"] as! String) { (fetchedImage) in
            if let fetchedImage = fetchedImage {
                DispatchQueue.main.async {
                    cell.issueImage.image = fetchedImage
                }
            }
        }
        cell.isSelected = false
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
