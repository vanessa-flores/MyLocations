//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Vanessa Flores on 9/2/20.
//  Copyright © 2020 Rising Dev Habits. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    
    return formatter
}()

class LocationDetailsViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var addPhotoLabel: UILabel!
    @IBOutlet private weak var imageHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    var managedObjectContext: NSManagedObjectContext!
    var date = Date()
    var descriptionText = ""
    var observer: Any!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.isHidden = false
            addPhotoLabel.text = ""
            tableView.reloadData()
        }
    }
        
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                placemark = location.placemark
            }
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = locationToEdit {
            title = "Edit Location"
            
            if location.hasPhoto {
                if let savedImage = location.photoImage {
                    show(image: savedImage)
                }
            }
        }
        
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = format(date: date)
        
        // Hide keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        
        listenForBackgroundNotification()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 44.0
        let descriptionHeight: CGFloat = 88.0
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return descriptionHeight
        } else if indexPath.section == 1 && indexPath.row == 0 {
            if let image = imageView.image {
                let aspectRatio = image.size.width / image.size.height
                let height = self.view.frame.width / aspectRatio

                return height
            } else {
                return defaultHeight
            }
        } else {
            return defaultHeight
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func done() {
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)

        let location: Location
        
        if let tempLocation = locationToEdit {
            hudView.text = "Updated"
            location = tempLocation
        } else {
            hudView.text = "Tagged"
            location = Location(context: managedObjectContext)
            location.photoID = nil
        }
        
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        
        // Save image
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: location.photoURL, options: .atomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    @objc private func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        
        descriptionTextView.resignFirstResponder()
    }
    
    // MARK: - Helpers
    
    private func string(from placemark: CLPlacemark) -> String {
        var line = ""
        line.add(text: placemark.subThoroughfare)
        line.add(text: placemark.thoroughfare, separatedBy: " ")
        line.add(text: placemark.locality, separatedBy: ", ")
        line.add(text: placemark.administrativeArea, separatedBy: ", ")
        line.add(text: placemark.postalCode, separatedBy: ", ")
        line.add(text: placemark.country, separatedBy: ", ")
        
        return !line.isEmpty ? line : "No Address Found"
    }
    
    private func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    private func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        addPhotoLabel.text = ""
        tableView.reloadData()
    }
    
    private func listenForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName: UIScene.didEnterBackgroundNotification, object: nil, queue: OperationQueue.main) { [weak self] _ in
            guard let self = self else { return }
            
            if self.presentedViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
            
            self.descriptionTextView.resignFirstResponder()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Image helper methods
    
    private func takePhotoWithCamera() {
        let imagePicker = MyImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        imagePicker.view.tintColor = view.tintColor
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        imagePicker.view.tintColor = view.tintColor
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    private func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionCancel)
        let actionPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })
        alert.addAction(actionPhoto)
        let actionLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
        })
        alert.addAction(actionLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if let finalImage = image {
            self.image = finalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
