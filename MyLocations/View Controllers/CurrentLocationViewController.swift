//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Vanessa Flores on 9/1/20.
//  Copyright © 2020 Rising Dev Habits. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var getButton: UIButton!
    
    // MARK: - Properties
    
    let locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation: Bool = false
    var lastLocationError: Error?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }

    // MARK: - Actions
    
    @IBAction private func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        location = newLocation
        updateLabels()
    }
    
    // MARK: - Helpers
    
    private func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            
            messageLabel.text = statusMessage
        }
    }
    
    private func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
}

