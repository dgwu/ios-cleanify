//
//  ActDetailViewController.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 21/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit
protocol ActDetailViewControllerDelegate {
    func updateEvent(event: CleanifyEvent)
}
class ActDetailViewController: UIViewController {

    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDatetimeLabel: UILabel!
    @IBOutlet weak var eventLocationDescriptionLabel: UILabel!
    
    @IBOutlet weak var eventParticipateButton: UIButton!
    
    var event: CleanifyEvent?
    var delegate: ActDetailViewControllerDelegate?
    let cleanifyApi = CleanifyApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        displayDetail()
        setupButtonView()
    }
    
    func setupButtonView() {
        self.eventParticipateButton.layer.cornerRadius = 5
        
        if let event = self.event, event.isParticipated {
            self.eventParticipateButton.isHidden = true
        }
    }
    
    func displayDetail() {
        guard let event = self.event else {
            return
        }
        
        self.navigationItem.title = event.title
        
        eventTitleLabel.text = event.title
        eventDescriptionLabel.text = event.body
        eventDatetimeLabel.text = event.heldAt
        
        eventLocationDescriptionLabel.text = event.locationDesc
        
        eventImageView.image = UIImage.init(named: "Default Profile Image")
        GeneralHelper.fetchImage(from: event.photoURL) { (fetchedImage) in
            if let fetchedImage = fetchedImage {
                DispatchQueue.main.async {
                    self.eventImageView.image = fetchedImage
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isLoggedIn() -> Bool {
        let token = getUserToken()
        
        if (token != "") {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func participateEvent() {
        if (isLoggedIn()) {
            let loadingAlert = GeneralHelper.getLoadingAlert()
            self.navigationController?.present(loadingAlert, animated: true, completion: nil)
            
            guard let event = event else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.cleanifyApi.participateEvent(eventId: event.id, userToken: getUserToken()) { (isDone) in
                if isDone {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                        loadingAlert.dismiss(animated: true, completion: nil)
                        loadingAlert.dismiss(animated: true, completion: {
                            DispatchQueue.main.async {
                                let notifyAlert = GeneralHelper.getDefaultAlert(message: "Success")
                                self.navigationController?.present(notifyAlert, animated: true, completion: nil)
                                self.event?.isParticipated = true
                                self.delegate?.updateEvent(event: self.event!)
                                self.setupButtonView()
                            }
                        })
                    }
                }
            }
        } else {
            // redirect to login page
            let vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}
