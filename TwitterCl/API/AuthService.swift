//
//  AuthService.swift
//  TwitterCl
//
//  Created by Abdullah on 26/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, withPassword password: String, completion: AuthDataResultCallback?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)

    }
    
    func registerUser(credentials: AuthCredentials, view: UIView, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in

                if let imageError = error {
                    print(imageError.localizedDescription)
                    view.removeBluerLoader()
                    return
                }
                
                guard let profileImageUrl = url?.absoluteString else { return }

                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("Error logging in: \(error.localizedDescription)")
                        view.removeBluerLoader()
                        return
                    }
   
                    //User successfully created, update data on database.
                    guard let uid = result?.user.uid else { view.removeBluerLoader() ; return }
                    
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullname,
                                  "profileImageUrl": profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
                
            }
            
        }
    }
}
