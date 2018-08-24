//
//  ActDetailViewController.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 21/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ActDetailViewController: UIViewController {

    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDatetimeLabel: UILabel!
    @IBOutlet weak var eventLocationDescriptionLabel: UILabel!
    
    var event: CleanifyEvent?
    let cleanifyApi = CleanifyApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayDetail()
    }
    
    func displayDetail() {
        guard let event = event else {
            return
        }
        
        self.navigationItem.title = "Act!"
        
        eventImageView.image = UIImage.init(named: "Profile Image")
        eventTitleLabel.text = event.title
        eventDescriptionLabel.text = event.body
        eventDatetimeLabel.text = event.heldAt
        
        eventLocationDescriptionLabel.text = event.locationDesc
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isLoggedIn() -> Bool {
        return true
    }
    
    @IBAction func participateEvent() {
        if (isLoggedIn()) {
            guard let event = event else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.cleanifyApi.participateEvent(eventId: event.id, userToken: "sejok") { (isDone) in
                if isDone {
                    print("its done")
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        } else {
            // redirect to login page
        }
    }
    
}
