//
//  UserService.swift
//  TwitterCl
//
//  Created by Abdullah on 27/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation
import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
        
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUID).updateChildValues([uid:1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUID:1], withCompletionBlock: completion)
        }
        
    }
    
    func unfollowUser(uid: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUID).child(uid).removeValue { (error, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUID).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUID).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
}
