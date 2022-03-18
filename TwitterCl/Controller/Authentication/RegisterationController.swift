//
//  RegisterationController.swift
//  TwitterCl
//
//  Created by Abdullah on 24/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import Firebase

class RegisterationController: ImagePickerViewController {
    
    //MARK: - Properties
    
    private var userProfileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addProfilePhotoTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities.inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities.inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities.inputContainerView(withImage: image, textField: fullNameTextField)
        return view
    }()
    
    private lazy var userNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities.inputContainerView(withImage: image, textField: userNameTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities.textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities.textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = Utilities.textField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let userNameTextField: UITextField = {
        let tf = Utilities.textField(withPlaceholder: "User Name")
        return tf
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities.attributedButton("Already have an account?", "Log In")
        button.addTarget(self, action: #selector(showLogIn), for: .touchUpInside)
        return button
    }()
    
    private let registerationButton: UIButton = {
        let button = Utilities.authenticationButton(withText: "Sign Up")
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fullNameTextField.delegate = self
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func showLogIn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addProfilePhotoTapped() {
        showImageSources()
    }
    
    @objc func registerButtonTapped() {
        
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        userNameTextField.endEditing(true)
        fullNameTextField.endEditing(true)
        
        view.showBlurLoader()
        
        guard let profileImage = userProfileImage else {
            print("Error Please Select a profile Image")
            self.view.removeBluerLoader()
            return
        }
        
        guard let email = emailTextField.text else { self.view.removeBluerLoader() ; return }
        guard let password = passwordTextField.text else { self.view.removeBluerLoader() ; return }
        guard let fullname = fullNameTextField.text else { self.view.removeBluerLoader() ; return }
        guard let username = userNameTextField.text?.lowercased() else { self.view.removeBluerLoader() ; return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials, view: self.view) { (error, ref) in
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { self.view.removeBluerLoader() ; return }
            guard let tab = window.rootViewController as? ContainerController else { self.view.removeBluerLoader() ; return }
            
            tab.homeController.authenticateUserAndConfigureUI()
            
            self.view.removeBluerLoader()
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "twitterBlue")
        
        //        imagePicker.delegate = self
        //        imagePicker.allowsEditing = true
        
        //Adding add photo button to login screen.
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 25)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullNameContainerView,
                                                   userNameContainerView,
                                                   registerationButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 20, paddingRight: 40)
    }
}

//MARK: - UIImagePickerControllerDelegate
extension RegisterationController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.userProfileImage = profileImage
        
        plusPhotoButton.layer.cornerRadius = 128/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension RegisterationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//MARK: - ViewAdjustments
extension RegisterationController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
