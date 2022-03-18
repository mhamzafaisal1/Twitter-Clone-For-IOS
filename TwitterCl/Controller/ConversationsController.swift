//
//  ConversationsController.swift
//  TwitterCl
//
//  Created by Abdullah on 23/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

class ConversationsController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
    
}
