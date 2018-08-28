//
//  GeneralHelper.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 27/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

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
    
    static func getCleanifyGreen() -> UIColor {
        return #colorLiteral(red: 0.5152163506, green: 0.5884165168, blue: 0.4317173958, alpha: 1)
    }
    static func getActiveGreen() -> UIColor {
        return #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
    }
}
