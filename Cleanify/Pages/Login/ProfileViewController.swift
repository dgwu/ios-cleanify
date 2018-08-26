//
//  ProfileViewController.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 24/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameLbl: UILabel!
    
    let menuArr:[String] = ["User Information", "Event Participant", "Statistics", "Report Issue", "Settings"]
    @IBOutlet weak var tabView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tabView.delegate = self
        tabView.dataSource = self
        
        doHttpPost(url: USER_DETAIL_URL, request: ["api_token" : getUserToken()]) { (result) in
            DispatchQueue.main.async {
                let user = result["user"] as! [String : Any]
//                print("USER : \(user)")
//                UserDefaults.standard.set(result["user"], forKey: USER_SESSION)
//                UserDefaults.standard.synchronize();
                self.nameLbl.text = "\(user["first_name"] ?? " ") \(user["last_name"] ?? " ")"
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! ProfileViewCell
        cell.menu.text = menuArr[indexPath.row]
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
