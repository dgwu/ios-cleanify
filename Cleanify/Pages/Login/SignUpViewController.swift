//
//  SignUpViewController.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 27/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        emailTxt.delegate = self
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        passwordTxt.delegate = self
        confirmPasswordTxt.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        if(passwordTxt.text != confirmPasswordTxt.text) {
            self.present(GeneralHelper.getDefaultAlert(message: "Password doesn't match"), animated: true, completion: nil)
            return
        }
        var req: [String : Any] = [:]
        req["email"] = emailTxt.text
        req["password"] = passwordTxt.text
        req["first_name"] = firstNameTxt.text
        req["last_name"] = lastNameTxt.text
        
        doHttpPost(url: REGISTER, request: req) { result in
            DispatchQueue.main.async {
                let message = "Register Successed"
                if result["isValid"] as! Bool == true {
                    setUserToken(userToken: result["user_token"] as! String)
                    let dialogAlert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
                    let okButton = UIAlertAction.init(title: "Ok", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "backToProfile", sender: nil)
                    })
                    dialogAlert.addAction(okButton)
                    self.present(dialogAlert, animated: true, completion: nil)
                } else {
                    let alert = GeneralHelper.getDefaultAlert(message: "Email has been used")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder?
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
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
