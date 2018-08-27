//
//  ProfileViewController.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 24/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var dummyView: UIView!
    let menuArr:[String] = ["User Information", "Event Participant", "Statistics", "Report Issue", "Settings", "Logout"]
    @IBOutlet weak var tabView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dummyView.isHidden = false
        tabView.delegate = self
        tabView.dataSource = self
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
//        tabBarController.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tabView.indexPathForSelectedRow {
            tabView.deselectRow(at: indexPath, animated: true)
        }
        
        doHttpPost(url: USER_DETAIL_URL, request: ["api_token" : getUserToken()]) { (result) in
            DispatchQueue.main.async {
                if result["isValid"] as! Bool == true {
                    self.dummyView.isHidden = true
                    let user = result["user"] as! [String : Any]
                    self.nameLbl.text = "\(user["first_name"] ?? " ") \(user["last_name"] ?? " ")"
                } else {
                    self.dummyView.isHidden = false
                    let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
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
        cell.isSelected = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuArr[indexPath.row] == "Logout" {
            setUserToken(userToken: "")
            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
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
