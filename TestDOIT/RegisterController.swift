//
//  RegisterController.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import Photos
import IQKeyboardManager
import CoreLocation

final class RegisterController: UIViewController, ImagePickerProtocol {
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var userNameTextField: UITextField!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var sendButton: UIButton!

    fileprivate var avatarImage: UIImage?
    fileprivate let server = Server()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Register", comment: "Register title")
        avatarImageView.layer.masksToBounds = true
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendButton.layer.cornerRadius = 3
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }

    @IBAction func closeKeyboardClicked(_ sender: UITapGestureRecognizer) {
        closeKeyboard()
    }

    @IBAction func chooseImageTap(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        startChooseImage(with: imagePicker)
    }

    @IBAction func sendButtonClicked(_ sender: UIButton) {
        guard let avatarImage = avatarImage else {
            showText(NSLocalizedString("choose avatar image", comment: "RegisterController"))
            return
        }
        guard let email = emailTextField.text, !email.isEmpty, !email.isBlank else {
            showText(NSLocalizedString("fill email text field", comment: "RegisterController"))
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty, !password.isBlank else {
            showText(NSLocalizedString("fill password text field", comment: "RegisterController"))
            return
        }
        sender.isEnabled = false
        let parameter = RegisterParameterModel(userName: userNameTextField.text, email: email, password: password, avatar: avatarImage)
        server.register(parameter) { result in
            if case .failure(let error as ServerError) = result {
                sender.isEnabled = true
                showText(error.localizedDescription)
                return
            }
            if case .success(let token) = result {
                Token.shared.userToken = token
                if let controller = Storyboards.main {
                    // I don't know why window need two questionmarks to unwrap it
                    UIApplication.shared.delegate?.window??.rootViewController = controller
                } else {
                    log("can't get \(Storyboards.Name.main) storyboard")
                }
            }
        }
    }
}

extension RegisterController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            closeKeyboard()
        } else {
            IQKeyboardManager.shared().goNext()
        }
        return true
    }
}

extension RegisterController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            showText(NSLocalizedString("Can't get image", comment: "RegisterController"))
            return
        }
        avatarImage = image
        avatarImageView.image = image
    }
}
