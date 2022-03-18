//
//  ContainerController.swift
//  TwitterCl
//
//  Created by Abdullah on 27/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import Foundation

import UIKit

class ContainerController: UIViewController {
    //MARK: - Properties
    
    var menuController: MenuController!
    var centerController: UIViewController!
    let homeController = MainTabController()
    var isExpanded = false
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .darkContent
    //    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    //MARK: - Handlers
    
    func configureHomeController() {
        homeController.menuDelegate = self
        centerController = homeController
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        
        if menuController != nil {
            self.menuController.view.removeFromSuperview()
            self.menuController.removeFromParent()
            self.menuController = nil
        }
        
        //add our menu controller
        menuController = MenuController(user: homeController.user)
        menuController.delegate = self
        view.insertSubview(menuController.view, at: 0)
        addChild(menuController)
        menuController.didMove(toParent: self)
        
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        
        if shouldExpand {
            //show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
                
            }, completion: nil)
        } else {
            //hide menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                //commented it as I can complete my access through main tab bar only
                //                guard let nav = self.homeController.viewControllers?[0] as? UINavigationController else { return }
                //                guard let feed = nav.viewControllers.first as? FeedController else { return }
                
                //                feed.didSelectMenuOption(menuOption: menuOption)
                self.homeController.handleMenuToggle(forMenuOption: menuOption)
                if menuOption == .Logout {
                    self.menuController.view.removeFromSuperview()
                    self.menuController.removeFromParent()
                    self.menuController = nil
                }
                
            }
        }
        
        //Only animate if device is iphone X or higher
        if UIScreen.main.bounds.size.height >= 812 {
            //uncomment it. had a problem on my simmulator
            //            animateStatusBar()
        }
        
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.setNeedsStatusBarAppearanceUpdate()
            
        }, completion: nil)
    }
    
    
}

extension ContainerController: MainTabControllerDelegate {
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
    
}
