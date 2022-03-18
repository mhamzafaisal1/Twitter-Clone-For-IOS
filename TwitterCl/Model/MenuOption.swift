//
//  MenuOption.swift
//  TwitterCl
//
//  Created by Abdullah on 28/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

enum MenuOption: Int {
    case Profile
    case Lists
    case Logout
    
    var description: String {
        switch self {
        case .Profile:
            return "Profile"
        case .Lists:
            return "Lists"
        case .Logout:
            return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile:
            return #imageLiteral(resourceName: "ic_person_outline_white_2x")
        case .Lists:
            return #imageLiteral(resourceName: "ic_menu_white_3x")
        case .Logout:
            return #imageLiteral(resourceName: "logout")
        }
    }
    
}
