//
//  ImagePickerProtocol.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 29.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation

protocol ImagePickerProtocol {
}

extension ImagePickerProtocol where Self: UIViewController {

    func startChooseImage(with imagePicker: UIImagePickerController) {
        let presentPhotoLibraryImagePicker = { [weak self] () -> Void in
            guard let welf = self else { return }
            imagePicker.sourceType = .photoLibrary
            welf.present(imagePicker, animated: true, completion: nil)
        }
        let presentCameraImagePicker = { [weak self] () -> Void in
            guard let welf = self else { return }
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            welf.present(imagePicker, animated: true, completion: nil)
        }
        let actionSheet = UIAlertController(title: NSLocalizedString("Get image from:", comment: "RegisterController"), message: nil, preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: NSLocalizedString("Photo library", comment: "RegisterController"), style: .default) { [weak self] _ in
            guard let welf = self else { return }
            welf.dismiss(animated: true, completion: nil)
            presentPhotoLibraryImagePicker()
        }
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "RegisterController"), style: .default) { [weak self] _ in
            guard let welf = self else { return }
            welf.dismiss(animated: true, completion: nil)
            presentCameraImagePicker()
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "RegisterController"), style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary), UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(photoLibrary)
            actionSheet.addAction(camera)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true, completion: nil)
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            presentPhotoLibraryImagePicker()
        } else if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentCameraImagePicker()
        }
    }
}
