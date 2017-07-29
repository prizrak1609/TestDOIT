//
//  UploadImageController.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 29.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import CoreLocation

final class UploadImageController: UIViewController, ImagePickerProtocol {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionTextField: UITextField!
    @IBOutlet fileprivate weak var hashtagTextField: UITextField!

    fileprivate var uploadImageButton: UIBarButtonItem!
    fileprivate var selectedImage: UIImage?
    fileprivate var imageLatitude = "0.0"
    fileprivate var imageLongitude = "0.0"
    fileprivate let server = Server()
    fileprivate let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        title = NSLocalizedString("Upload Image", comment: "UploadImageController title")
        uploadImageButton = UIBarButtonItem(image: #imageLiteral(resourceName: "checkMark"), style: .plain, target: self, action: #selector(uploadImage))
        navigationItem.rightBarButtonItem = uploadImageButton
    }

    @IBAction func selectImageClicked(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        startChooseImage(with: imagePicker)
    }

    @IBAction func closeKeyboardClicked(_ sender: UITapGestureRecognizer) {
        closeKeyboard()
    }

    func uploadImage() {
        guard let image = selectedImage else {
            showText(NSLocalizedString("Choose image to upload", comment: "UploadImageController"))
            return
        }
        if let hashtagsString = hashtagTextField.text {
            let hashtagsArray = hashtagsString.trimmed.components(separatedBy: " ")
            for hastag in hashtagsArray {
                if let firstCharacter = hastag.characters.first, firstCharacter != "#" {
                    showText(NSLocalizedString("all hashtags need to start with #", comment: "UploadImageController"))
                    return
                }
            }
        }
        uploadImageButton.isEnabled = false
        let param = UploadImageParametersModel(image: image,
                                               description: descriptionTextField.text,
                                               hashtag: hashtagTextField.text,
                                               latitude: imageLatitude,
                                               longitude: imageLongitude,
                                               token: Token.shared.userToken)
        server.uploadImage(param) { [weak self] result in
            guard let welf = self else { return }
            if case .failure(let error as ServerError) = result {
                welf.uploadImageButton.isEnabled = true
                showText(error.localizedDescription)
                return
            }
            welf.navigationController?.popViewController(animated: true)
        }
    }
}

extension UploadImageController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        imageLatitude = "\(location.coordinate.latitude)"
        imageLongitude = "\(location.coordinate.longitude)"
        uploadImageButton.isEnabled = true
    }
}

extension UploadImageController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        uploadImageButton.isEnabled = false
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            showText(NSLocalizedString("Can't get image", comment: "UploadImageController"))
            return
        }
        selectedImage = image
        imageView.image = image
        if let metadata = info[UIImagePickerControllerMediaMetadata] as? [AnyHashable : Any],
            let gps = metadata["{GPS}"] as? [AnyHashable : Any],
            let latitude = gps["Latitude"] as? String,
            let longitude = gps["Longitude"] as? String {

            imageLatitude = latitude
            imageLongitude = longitude
            uploadImageButton.isEnabled = true
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}
