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
    
    var event = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayDetail()
    }
    
    func displayDetail() {
        eventImageView.image = UIImage.init(named: "Profile Image")
//        "title" : "another test",
//        "photo_url" : "uhuy",
//        "description" : "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//        "location_desc" : "AEON MALL BSD",
//        "location_latitude" : -6.304715,
//        "location_longitude" : 106.643997,

        if let eventTitle = self.event["title"] as? String {
            eventTitleLabel.text = eventTitle
        }
        if let eventDescription = self.event["description"] as? String {
            eventDescriptionLabel.text = eventDescription
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
