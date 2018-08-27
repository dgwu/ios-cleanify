//
//  LoginViewController.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 20/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var formView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        formView.layer.shadowOpacity = 0.7
        formView.layer.shadowOffset = CGSize.zero
        formView.layer.shadowRadius = 5
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        var req = [String:Any]()
        req["email"] = emailTxt.text
        req["password"] = passwordTxt.text
        doHttpPost(url: LOIGN_URL, request: req) { result in
            if result["isValid"] as! Bool == true {
                print("result token \(result["user_token"] as! String)")
                UserDefaults.standard.set(result["user_token"] as! String, forKey: "userToken")
                UserDefaults.standard.synchronize();
            }
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