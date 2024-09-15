//
//  TaskDetailViewController.swift
//  lab-task-squirrel
//
//  Created by Victoria Mckinnie on 09/13/24.
//

import UIKit
import MapKit
import PhotosUI

class TaskDetailViewController: UIViewController, PHPickerViewControllerDelegate, MKMapViewDelegate {

    @IBOutlet private weak var completedImageView: UIImageView!
    @IBOutlet private weak var completedLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var attachPhotoButton: UIButton!
    @IBOutlet private weak var mapView: MKMapView!

    var task: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        updateUI()
    }

    func updateUI() {
        guard let task = task else { return }
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        completedLabel.text = task.isComplete ? "Completed" : "Incomplete"
        attachPhotoButton.isHidden = task.isComplete
        mapView.isHidden = !task.isComplete

        if let image = task.image, let location = task.imageLocation {
            completedImageView.image = image
            addAnnotationToMap(at: location)
        }
    }

    private func addAnnotationToMap(at location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = task?.title
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
    }

    @IBAction func attachPhoto(_ sender: UIButton) {
        checkPhotoLibraryAuthorization()
    }

    private func checkPhotoLibraryAuthorization() {
        // Check the current authorization status for photo library access
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            // Request photo library access
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                switch status {
                case .authorized:
                    // The user authorized access to their photo library
                    DispatchQueue.main.async {
                        self?.presentImagePicker()
                    }
                case .denied, .restricted, .notDetermined, .limited:
                    // Show an alert suggesting the user update their settings
                    DispatchQueue.main.async {
                        self?.showSettingsAlert()
                    }
                @unknown default:
                    break
                }
            }
        } else {
            // If already authorized, present the photo picker
            presentImagePicker()
        }
    }

    private func presentImagePicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Photo Access Required",
            message: "We need access to your photo library to attach photos to tasks. Please enable access in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let image = object as? UIImage {
                result.itemProvider.loadItem(forTypeIdentifier: "public.jpeg", options: nil) { item, error in
                    if let data = item as? Data,
                       let source = CGImageSourceCreateWithData(data as CFData, nil),
                       let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
                       let gps = properties[kCGImagePropertyGPSDictionary] as? [CFString: Any] {
                        let lat = gps[kCGImagePropertyGPSLatitude] as! Double
                        let lon = gps[kCGImagePropertyGPSLongitude] as! Double
                        let location = CLLocation(latitude: lat, longitude: lon)
                        
                        DispatchQueue.main.async {
                            self?.task?.set(image, with: location)
                            self?.updateUI()
                        }
                    }
                }
            }
        }
    }
}

