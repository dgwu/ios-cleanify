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
    var selectedEvent: CleanifyEvent?
    
    let dummyEvents = [
        [
            "title" : "another test",
            "photo_url" : "uhuy",
            "description" : "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
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
        ]
    ]
    
    var cleanifyEvents = [CleanifyEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        self.eventTableView.rowHeight = 300
        
        loadEvents()
    }
    
    func loadEvents() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let loadingAlert = GeneralHelper.getLoadingAlert()
        self.navigationController?.present(loadingAlert, animated: true, completion: nil)
        
        let cleanifyApi = CleanifyApi()
        cleanifyApi.fetchEventList { (events) in
            if let events = events {
                self.cleanifyEvents = events
                
                DispatchQueue.main.async {
                    self.setupMap()
                    self.eventTableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    loadingAlert.dismiss(animated: true, completion: nil)
                }
            }
        }
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
//        print(self.mapView.userLocation.coordinate.latitude)
//        print(self.mapView.userLocation.coordinate.longitude)
        
        for event in cleanifyEvents {
            let locationPoint = MKPointAnnotation()
            locationPoint.title = event.title
            locationPoint.subtitle = event.locationDesc
            locationPoint.coordinate = CLLocationCoordinate2D(latitude: event.locationLatitude,
                                                              longitude: event.locationLongitude)
            mapView.addAnnotation(locationPoint)
        }
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
        return self.cleanifyEvents.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActCell", for: indexPath) as! ActTableViewCell
        let event = self.cleanifyEvents[indexPath.section]
        
        cell.eventImageView.image = UIImage.init(named: "Default Profile Image")
        cell.eventTitleLabel.text = event.title
        cell.eventDescriptionLabel.text = event.description
        
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
        let event = self.cleanifyEvents[indexPath.section]
        self.selectedEvent = event
        
        performSegue(withIdentifier: "ToDetail", sender: self)
    }
    
    // MARK : Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToDetail") {
            if let destination = segue.destination as? ActDetailViewController {
                destination.event = self.selectedEvent
                print("segue to act detail")
            } else {
                print("failed to segue to act detail")
            }
        }
    }
}
