//
//  ActListViewController.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 20/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit
import MapKit

class ActListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, ActDetailViewControllerDelegate {
    
    
    @IBOutlet weak var mapViewOutlet: UIView!
    @IBOutlet weak var listViewOutlet: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventTableView: UITableView!
    
    var selectedEvent: CleanifyEvent?
    var locationManager = CLLocationManager()
    var cleanifyEvents = [CleanifyEvent]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadEvents), for: .valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        self.eventTableView.rowHeight = UITableViewAutomaticDimension
        self.eventTableView.estimatedRowHeight = 270
        
        loadEvents()
        self.eventTableView.addSubview(self.refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.eventTableView.reloadData()
    }
    
    @objc func loadEvents() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let loadingAlert = GeneralHelper.getLoadingAlert()
        self.navigationController?.present(loadingAlert, animated: true, completion: nil)
        
        let cleanifyApi = CleanifyApi()
        if (isUserLoggedIn()) {
            cleanifyApi.fetchEventListWithUser { (events) in
                if let events = events {
                    self.cleanifyEvents = events
                }
                DispatchQueue.main.async {
                    self.setupView()
                    loadingAlert.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            cleanifyApi.fetchEventList { (events) in
                if let events = events {
                    self.cleanifyEvents = events
                }
                DispatchQueue.main.async {
                    self.setupView()
                    loadingAlert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func setupView() {
        self.setupMap()
        self.eventTableView.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.refreshControl.endRefreshing()
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
        
        GeneralHelper.fetchImage(from: event.photoURL) { (fetchedImage) in
            if let fetchedImage = fetchedImage {
                DispatchQueue.main.async {
                    cell.eventImageView.image = fetchedImage
                }
            }
        }
        
        // add border and color
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = (event.isParticipated) ? GeneralHelper.getActiveGreen().cgColor : UIColor.lightGray.cgColor
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
                destination.delegate = self
                destination.event = self.selectedEvent
                print("segue to act detail")
            } else {
                print("failed to segue to act detail")
            }
        }
    }
    
    // MARK : Event Detail Delegate
    func updateEvent(event: CleanifyEvent) {
        let indexPath = self.eventTableView.indexPathForSelectedRow
        
        if let indexPath = indexPath {
            self.cleanifyEvents[indexPath.section] = event
            print(event.isParticipated)
        }
    }
}
