//
//  GeneralHelper.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 27/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class GeneralHelper {
    static func getLoadingAlert() -> UIAlertController {
        let loadingAlertController = UIAlertController.init(title: nil, message: "Loading..", preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(frame: loadingAlertController.view.bounds)
        
        indicator.frame.origin.x = -60
        indicator.activityIndicatorViewStyle = .gray
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingAlertController.view.addSubview(indicator)
        indicator.startAnimating()
        
        return loadingAlertController
    }
}
