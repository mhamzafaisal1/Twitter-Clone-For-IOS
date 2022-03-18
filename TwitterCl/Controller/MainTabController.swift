//
//  MainTabController.swift
//  TwitterCl
//
//  Created by Abdullah on 23/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    var menuDelegate: MainTabControllerDelegate?
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "twitterBlue")
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Selector
    
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let controller = UploadTweetController(user: user, config: .tweet)
        let nav = UINavigationController(rootViewController: controller )
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
//        logUserOut()
        view.backgroundColor = UIColor(named: "twitterBlue")
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { (user) in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureViewController()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
            self.authenticateUserAndConfigureUI()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Helper
    
    func configureUI() {
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
        //This is the original code to render button without helper method.
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        actionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
//        actionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
//        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64).isActive = true
//        actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        
    }
    
    func configureViewController() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationFeed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let navigationExplore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notification = NotificationController()
        let navigationNotification = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notification)
        
        let conversation = ConversationsController()
        let navigationConversation = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversation)
        
        viewControllers = [navigationFeed, navigationExplore, navigationNotification, navigationConversation]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
        
    }

}

extension MainTabController: MainTabControllerDelegate {
    
    func handleMenuToggle(forMenuOption option: MenuOption?) {
        if let option = option {
            if option == .Logout {
                logUserOut()
            } else if option == .Profile {
                
                guard let user = user else { return }
                
                guard let nav = viewControllers?[0] as? UINavigationController else { return }
                guard let feed = nav.viewControllers.first as? FeedController else { return }
                
                let controller = ProfileController(user: user)
                feed.navigationController?.pushViewController(controller, animated: true)
            }
            return
        }
        menuDelegate?.handleMenuToggle(forMenuOption: option)
    }
    
}


