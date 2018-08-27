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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportTableView.delegate = self
        reportTableView.dataSource = self
        
        addReportButton.addTarget(self, action: #selector(addReportButtonTapped), for: UIControlEvents.touchUpInside)
        
        addReportButton.layer.cornerRadius = 22.5
        
        
        getReportList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getReportList(){
        // Get all report list
    }
    
    func getReportDetail(){
        
    }
    
    @objc func addReportButtonTapped(){
        
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

extension ReportViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ReportCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportDetailTableViewCell
        
        cell.reportDetailImage.image = #imageLiteral(resourceName: "Act! Icon")
        cell.reportDetailTitle.text = "Act Now"
        cell.reportDetailDescription.text = "It's time to act"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ReportDetailSegue", sender: indexPath)
    }
}
