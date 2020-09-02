//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Vanessa Flores on 9/2/20.
//  Copyright © 2020 Rising Dev Habits. All rights reserved.
//

import UIKit

class LocationDetailsViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    
    @IBAction private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func done() {
        navigationController?.popViewController(animated: true)
    }
    
    private func selectCategory() {
        
    }
    
    private func addPhoto() {
        
    }

}
