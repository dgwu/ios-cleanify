//
//  ActListViewController.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 20/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit
import MapKit

class ActListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapViewOutlet: UIView!
    @IBOutlet weak var listViewOutlet: UIView!
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var eventTableView: UITableView!
    
    let dummyEvents = [
        [
            "title" : "another test",
            "photo_url" : "uhuy",
            "description" : "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            "location_desc" : "AEON MALL BSD",
            "location_latitude" : -6.304715,
            "location_longitude" : 106.643997,
        ],
        [
            "title" : "another test 2",
            "photo_url" : "uhuy",
            "description" : "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            "location_desc" : "BRANZ BSD",
            "location_latitude" : -6.3017287,
            "location_longitude" : 106.642002,
        ],
        [
            "title" : "another test 3",
            "photo_url" : "uhuy",
            "description" : "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            "location_desc" : "BRANZ BSD",
            "location_latitude" : -6.3017287,
            "location_longitude" : 106.642001,
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        self.eventTableView.rowHeight = 300
        
        setupMap()
    }
    
    // MARK : Setup Map
    func setupMap() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 200, 200)
            mapView.setRegion(viewRegion, animated: true)
        }
        
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        
        
        self.mapView.showsUserLocation = true
        print(self.mapView.userLocation.coordinate.latitude)
        print(self.mapView.userLocation.coordinate.longitude)
        
        for event in dummyEvents {
            let locationPoint = MKPointAnnotation()
            locationPoint.title = event["title"] as! String
            locationPoint.subtitle = event["location_desc"] as! String
            locationPoint.coordinate = CLLocationCoordinate2D(latitude: event["location_latitude"] as! Double,
                                                              longitude: event["location_longitude"] as! Double)
            
            
            
            mapView.addAnnotation(locationPoint)
        }
        
//        let aeonMallBSD = MKPointAnnotation()
//        aeonMallBSD.title = "AEON MALL BSD"
//        aeonMallBSD.subtitle = "subtitle"
//        aeonMallBSD.coordinate = CLLocationCoordinate2D(latitude: -6.304715, longitude: 106.643997)
//        mapView.addAnnotation(aeonMallBSD)
    }
    
    // MARK : Actions
    @IBAction func switchView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapViewOutlet.isHidden = false;
            listViewOutlet.isHidden = true;
        case 1:
            mapViewOutlet.isHidden = true;
            listViewOutlet.isHidden = false;
        default:
            print("default")
        }
    }
    
    // MARK : Table View Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dummyEvents.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActCell", for: indexPath) as! ActTableViewCell
        
        cell.eventImageView.image = UIImage.init(named: "Profile Image")
        cell.eventTitleLabel.text = self.dummyEvents[indexPath.section]["title"] as! String
        cell.eventDescriptionLabel.text = self.dummyEvents[indexPath.section]["description"] as! String
        
        // add border and color
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true

        
        return cell
    }
    
    
    // MARK : Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dummyEvent = self.dummyEvents[indexPath.section]
        
        performSegue(withIdentifier: "ToDetail", sender: self)
    }
    
    // MARK : Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToDetail") {
            if let destination = segue.destination as? ActDetailViewController {
                print("berhasil yey")
            } else {
                print("failed")
            }
        }
    }
}
