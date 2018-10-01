//
//  AddReportViewController.swift
//  Cleanify
//
//  Created by Andre Tirta Wijaya on 24/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit
import CoreLocation

//protocol AddReportViewControllerDelegate {
//    func represhData()
//}

class AddReportViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var reportTitleTextField: UITextField!
    @IBOutlet weak var LocationDescriptionTextField: UITextField!
    @IBOutlet weak var reportDescriptionTextView: UITextView!
    @IBOutlet weak var chosenImageView: UIImageView!
//    @IBOutlet weak var LocationLongitudeLatitudeLabel: UILabel!
    @IBOutlet weak var uniqueView: UIScrollView!
    @IBOutlet weak var descriptionTextView: UIView!
    
//    var delegate: AddReportViewControllerDelegate?
    let reportDescriptionPlaceholderText = "Report Description..."
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    
    var activeField:UITextField?
    var lastOffset:CGPoint?
    var keyboardHeight:CGFloat?
    
    var Latitude:Double?
    var Longitude:Double?
    
    override func viewDidAppear(_ animated: Bool) {
        doHttpPost(url: USER_DETAIL_URL, request: ["api_token" : getUserToken()]) { (result) in
            DispatchQueue.main.async {
                if result["isValid"] as! Bool == true {
                    
//                    let user = result["user"] as! [String : Any]
                    
                } else {
                    
//                    let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
//                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        LocationDescriptionTextField.delegate = self
        imagePicker.delegate = self
        
        let bar = UIToolbar()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextToDescription))
        bar.items = [spacer, next]
        bar.sizeToFit()
        reportTitleTextField.inputAccessoryView = bar
        
        prettifyReportDescriptionTextView()
    
        findLocationTapped(self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == LocationDescriptionTextField{
            activeField = LocationDescriptionTextField
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func nextToDescription(){
        let bar = UIToolbar()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextToLocation))
        bar.items = [spacer, next]
        bar.sizeToFit()
        reportDescriptionTextView.inputAccessoryView = bar
        reportDescriptionTextView.becomeFirstResponder()
    }
    
    @objc func nextToLocation(){
        let bar = UIToolbar()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        bar.items = [spacer, done]
        bar.sizeToFit()
        activeField = LocationDescriptionTextField
        LocationDescriptionTextField.inputAccessoryView = bar
        LocationDescriptionTextField.becomeFirstResponder()
    }
    
    @objc func doneTapped(){
        activeField = nil
        LocationDescriptionTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prettifyReportDescriptionTextView(){
        reportDescriptionTextView.delegate = self
        textViewDidEndEditing(reportDescriptionTextView)
        
        reportDescriptionTextView.layer.cornerRadius = reportTitleTextField.layer.cornerRadius
        reportDescriptionTextView.layer.borderColor = reportTitleTextField.layer.borderColor
        reportDescriptionTextView.layer.borderWidth = reportTitleTextField.layer.borderWidth
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if LocationDescriptionTextField.isFirstResponder{
                if view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height/2
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @IBAction func findLocationTapped(_ sender: Any){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.Latitude=locValue.latitude
        self.Longitude=locValue.longitude
//        manager.location.
//        LocationLongitudeLatitudeLabel.text = "[\(locValue.latitude), \(locValue.longitude)]"
    }
    
    @IBAction func uploadPhotosTapped(_ sender: Any) {
        // pilih foto yang sudah ada atau akses kamera
        let alert = UIAlertController(title: "Photo Source", message: "Choose Your Photo Source", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: {(alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        // post ke api
        
        var request:[String:String]=[:]
                request["api_token"]="sejok"
                request["title"]=reportTitleTextField.text ?? "empty title"
                request["body"]=reportDescriptionTextView.text
                request["location_desc"]=LocationDescriptionTextField.text ?? "empty location description"
                request["location_longitude"]=String(Longitude ?? 0.0)
                request["location_latitude"]=String(Latitude ?? 0.0)
        
        CleanifyApi().postReportWithPhoto(photo: chosenImageView.image, apiPath: "postreport", parameters: request) { (result) in
            print("mashook")
//            self.delegate?.represhData()
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}

extension AddReportViewController:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.reportDescriptionTextView.textColor = .black
        
        if(self.reportDescriptionTextView.text == reportDescriptionPlaceholderText) {
            self.reportDescriptionTextView.text = ""
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            self.reportDescriptionTextView.text = reportDescriptionPlaceholderText
            self.reportDescriptionTextView.textColor = .lightGray
        }
    }
    
}

extension AddReportViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        print(image.size)
        chosenImageView.image = image
        
    }
    
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
