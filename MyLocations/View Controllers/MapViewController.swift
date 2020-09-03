//
//  MapViewController.swift
//  MyLocations
//
//  Created by Vanessa Flores on 9/3/20.
//  Copyright © 2020 Rising Dev Habits. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    
    @IBAction private func showUser() {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction private func showLocations() {
        
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
}
