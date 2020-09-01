//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Vanessa Flores on 9/1/20.
//  Copyright © 2020 Rising Dev Habits. All rights reserved.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var getButton: UIButton!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    
    @IBAction private func getLocation() {
        // do nothing yet
    }
}

