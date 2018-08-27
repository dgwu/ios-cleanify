//
//  AddReportViewController.swift
//  Cleanify
//
//  Created by Andre Tirta Wijaya on 24/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class AddReportViewController: UIViewController {

    @IBOutlet weak var reportTitleTextField: UITextField!
    @IBOutlet weak var reportDescriptionTextView: UITextView!
    
    let reportDescriptionPlaceholderText = "Report Description..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prettifyReportDescriptionTextView()
        
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
