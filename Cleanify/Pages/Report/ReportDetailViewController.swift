//
//  ReportDetailViewController.swift
//  Cleanify
//
//  Created by Andre Tirta Wijaya on 27/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    let reportDetailTitle:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let reportDetailTitle = reportDetailTitle{
            titleLabel.text=reportDetailTitle
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
