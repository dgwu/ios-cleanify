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
    
    static func getDefaultAlert(message: String) -> UIAlertController {
        let alertController = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let closeButton = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(closeButton)
        
        return alertController
    }
    
    static func fetchImage(from urlString: String, completion: @escaping(UIImage?) -> Void) {
        let imageUrl = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data,
                let fetchedImage = UIImage(data: data) {
                completion(fetchedImage)
                return
            }
            completion(nil)
        }
        task.resume()
    }
}
