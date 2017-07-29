//
//  ViewController.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import IQKeyboardManager

final class LoginController: UIViewController {
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var loginButton: UIButton!
    @IBOutlet fileprivate weak var registerButton: UIButton!

    fileprivate let server = Server()

    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.layer.masksToBounds = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButton.layer.cornerRadius = 3
        registerButton.layer.cornerRadius = 3
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }

    @IBAction func closeKeyboardClicked(_ sender: UITapGestureRecognizer) {
        closeKeyboard()
    }

    @IBAction func loginButtonClicked(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, !email.isBlank else {
            showText(NSLocalizedString("Fill email field", comment: "LoginController"))
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty, !password.isBlank else {
            showText(NSLocalizedString("Fill password field", comment: "LoginController"))
            return
        }
        sender.isEnabled = false
        server.login(LoginParameterModel(email: email, password: password)) { result in
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

extension LoginController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            closeKeyboard()
        } else {
            IQKeyboardManager.shared().goNext()
        }
        return true
    }
}
