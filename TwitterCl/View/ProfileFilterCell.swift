//
//  ProfileFilterCell.swift
//  TwitterCl
//
//  Created by Abdullah on 03/04/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var option: ProfileFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Hello"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override var isSelected: Bool {
        
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) :
            UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? UIColor(named: TWIT_BLUE) : .lightGray
        }
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
